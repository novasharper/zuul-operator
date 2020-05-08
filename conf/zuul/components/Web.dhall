let Kubernetes = ../../Kubernetes.dhall

let Ambassador = ../../Ambassador.dhall

let F = ../functions.dhall

let InputWeb = (../input.dhall).Web.Type

in      \(app-name : Text)
    ->  \(input-web : InputWeb)
    ->  \(data-dir : List F.Volume.Type)
    ->  \(volumes : List F.Volume.Type)
    ->  \(env : List Kubernetes.EnvVar.Type)
    ->  let {- Only include ambassador mapping if public-facing url is provided
            -} mapping = Optional/fold Text input-web.public-url
            (Optional Ambassador.Mapping.Type)
            (     \(url : Text)
              ->  Some  ( F.mkMapping
                            app-name
                            "web"
                            9000
                            Ambassador.MappingOptions::{ host = Some url }
                        )
            )
            (None Ambassador.Mapping.Type)

        in  F.KubernetesComponent::{
            , Service = Some (F.mkService app-name "web" "api" 9000)
            , Mapping = mapping
            , Deployment = Some
                ( F.mkDeployment
                    app-name
                    F.Component::{
                    , name = "web"
                    , count = 1
                    , data-dir = data-dir
                    , volumes = volumes
                    , container = Kubernetes.Container::{
                      , name = "web"
                      , image = input-web.image
                      , args = Some [ "zuul-web", "-d" ]
                      , imagePullPolicy = Some "IfNotPresent"
                      , ports = Some
                        [ Kubernetes.ContainerPort::{
                          , name = Some "api"
                          , containerPort = 9000
                          }
                        ]
                      , env = Some env
                      , volumeMounts = Some (F.mkVolumeMount (data-dir # volumes))
                      }
                    }
                )
            }
