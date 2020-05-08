let Kubernetes = ./Kubernetes.dhall
let CertManager = ./CertManager.dhall
let Ambassador = ./Ambassador.dhall

let Union =
      < Kubernetes : Kubernetes.Resource
      | Issuer : CertManager.Issuer.Type
      | Certificate : CertManager.Certificate.Type
      | Ambassador : Ambassador.Resource
      >

in { Union = Union }
