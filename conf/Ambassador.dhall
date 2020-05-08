let Prelude = ./Prelude.dhall

let Kubernetes = ./Kubernetes.dhall

let Entry = { mapKey : Text, mapValue : Text }
let Dict = List Entry

let MappingOptions =
      { Type =
          { add_linkerd_headers : Optional (List Text)
          , add_request_headers : Optional (List Text)
          , add_response_headers : Optional (List Text)
          , ambassador_id : Optional Text
          , cluster_idle_timeout_ms : Optional Natural
          , connect_timeout_ms : Optional Natural
          , cors : Optional Dict
          , circuit_breakers : Optional Dict
          , enable_ipv4 : Optional Bool
          , enable_ipv6 : Optional Bool
          , grpc : Optional Bool
          , headers : Optional (List Text)
          , host : Optional Text
          , host_regex : Optional Bool
          , host_rewrite : Optional Text
          , idle_timeout_ms : Optional Natural
          , load_balancer : Optional Dict
          , method : Optional Text
          , method_regex : Optional Bool
          , prefix_regex : Optional Bool
          , rate_limits : Optional Dict
          , remove_request_headers : Optional (List Text)
          , remove_response_headers : Optional (List Text)
          , regex_headers : Optional (List Text)
          , rewrite : Optional Text
          , retry_policy : Optional Dict
          , timeout_ms : Optional Natural
          , tls : Optional Bool
          , use_websocket : Optional Bool
          }
      , default =
          { add_linkerd_headers = None (List Text)
          , add_request_headers = None (List Text)
          , add_response_headers = None (List Text)
          , ambassador_id = None Text
          , cluster_idle_timeout_ms = None Natural
          , connect_timeout_ms = None Natural
          , cors = None Dict
          , circuit_breakers = None Dict
          , enable_ipv4 = None Bool
          , enable_ipv6 = None Bool
          , grpc = None Bool
          , headers = None (List Text)
          , host = None Text
          , host_regex = None Bool
          , host_rewrite = None Text
          , idle_timeout_ms = None Natural
          , load_balancer = None Dict
          , method = None Text
          , method_regex = None Bool
          , prefix_regex = None Bool
          , rate_limits = None Dict
          , remove_request_headers = None (List Text)
          , remove_response_headers = None (List Text)
          , regex_headers = None (List Text)
          , rewrite = None Text
          , retry_policy = None Dict
          , timeout_ms = None Natural
          , tls = None Bool
          , use_websocket = None Bool
          }
      }

let MappingSpec =
      { Type =
          { prefix : Optional Text
          , service : Optional Text
          } //\\ MappingOptions.Type
      , default = MappingOptions.default
      }

let Mapping =
      { Type =
          { apiVersion : Text
          , kind : Text
          , metadata : Kubernetes.ObjectMeta.Type
          , spec : Optional MappingSpec.Type
          }
      , default =
          { apiVersion = "getambassador.io/v2"
          , kind = "Mapping"
          , spec = None MappingSpec.Type
          }
      }

let TCPMappingSpec =
      { Type =
          { address : Optional Text
          , ambassador_id : Optional Text
          , port : Text
          , idle_timeout_ms : Optional Natural
          , enable_ipv4 : Optional Bool
          , enable_ipv6 : Optional Bool
          }
      , default =
          { address = None Text
          , ambassador_id = None Text
          , idle_timeout_ms = None Natural
          , enable_ipv4 = None Bool
          , enable_ipv6 = None Bool
          }
      }

let TCPMapping =
      { Type =
          { apiVersion : Text
          , kind : Text
          , metadata : Kubernetes.ObjectMeta.Type
          , spec : Optional TCPMappingSpec.Type
          }
      , default =
          { apiVersion = "getambassador.io/v2"
          , kind = "TCPMapping"
          , spec = None TCPMappingSpec.Type
          }
      }

let Resource =
      < Mapping : Mapping.Type
      | TCPMapping : TCPMapping.Type
      >

in  { MappingOptions = MappingOptions
    , MappingSpec = MappingSpec
    , Mapping = Mapping
    , TCPMappingSpec = TCPMappingSpec
    , TCPMapping = TCPMapping
    , Resource = Resource
    }
