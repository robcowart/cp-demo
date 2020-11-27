#!/bin/bash

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "order": 0,
  "version": 1,
  "index_patterns": "audit-*",
  "settings": {
    "index": {
      "number_of_shards": 1,
      "number_of_replicas": 1,
      "refresh_interval": "10s",
      "codec": "best_compression",
      "mapping": {
        "total_fields" : {
          "limit": 1024
        }
      }
    }
  },
  "mappings": {
    "_source" : {
      "enabled" : true
    },
    "dynamic_templates": [
      {
        "string_fields": {
          "mapping": {
            "type": "keyword"
          },
          "match_mapping_type": "*",
          "match": "*"
        }
      }
    ],
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "action" : {
        "type" : "keyword"
      },
      "message" : {
        "type" : "text"
      },
      "specversion": {
        "type": "keyword"
      },
      "confluentRouting": {
        "dynamic": true,
        "type": "object",
        "properties": {
          "route" : {
            "type" : "keyword"
          }
        }
      },
      "source": {
        "type": "keyword"
      },
      "datacontenttype": {
        "type": "keyword"
      },
      "subject": {
        "type": "keyword"
      },
      "type": {
        "type": "keyword"
      },
      "data": {
        "dynamic": true,
        "type": "object",
        "properties": {
          "methodName" : {
            "type" : "keyword"
          },
          "authenticationInfo": {
            "dynamic": true,
            "type": "object",
            "properties": {
              "principal" : {
                "type" : "keyword"
              }
            }
          },
          "authorizationInfo": {
            "dynamic": true,
            "type": "object",
            "properties": {
              "rbacAuthorization": {
                "dynamic": true,
                "type": "object",
                "properties": {
                  "role" : {
                    "type" : "keyword"
                  },
                  "scope": {
                    "dynamic": true,
                    "type": "object",
                    "properties": {
                      "outerScope" : {
                        "type" : "keyword"
                      },
                      "clusters": {
                        "dynamic": true,
                        "type": "object",
                        "properties": {
                          "connect-cluster" : {
                            "type" : "keyword"
                          },
                          "kafka-cluster" : {
                            "type" : "keyword"
                          },
                          "ksql-cluster" : {
                            "type" : "keyword"
                          },
                          "schema-registry-cluster" : {
                            "type" : "keyword"
                          }
                        }
                      }
                    }
                  }
                }
              },
              "resourceType" : {
                "type" : "keyword"
              },
              "operation" : {
                "type" : "keyword"
              },
              "patternType" : {
                "type" : "keyword"
              },
              "granted" : {
                "type" : "boolean"
              },
              "resourceName" : {
                "type" : "keyword"
              }
            }
          },
          "request": {
            "dynamic": true,
            "type": "object",
            "properties": {
              "correlation_id" : {
                "type" : "keyword"
              }
            }
          },
          "serviceName" : {
            "type" : "keyword"
          },
          "requestMetadata": {
            "dynamic": true,
            "type": "object",
            "properties": {
              "client_address" : {
                "type" : "keyword"
              }
            }
          },
          "resourceName" : {
            "type" : "keyword"
          }
        }
      }
    }
  }
}
EOF
)

curl -XPUT -H "${HEADER}" --data "${DATA}" 'http://localhost:9200/_template/audit?pretty'
echo
