allow_k8s_contexts("kind-kind")

# Build main app with live_update enabled
docker_build('markedb', 'backend',
    dockerfile="backend/Dockerfile",
    live_update=[

    ],
)

# Install Operators with helm
# https://docs.tilt.dev/helm
# https://github.com/tilt-dev/tilt-extensions/tree/master/helm_resource
load('ext://helm_resource', 'helm_resource', 'helm_repo')
helm_repo('zalando',        'https://opensource.zalando.com/postgres-operator/charts/postgres-operator', labels=['Helm_Repos'])
helm_resource('zalando-pgo',
              chart='zalando/postgres-operator',
              release_name='zalando-pgo',
              namespace="zalando",
              flags=['--create-namespace'],
              labels=['Operators'])

# Deploy app
k8s_yaml(kustomize('deploy/kubernetes/local-dev'))

# Tilt dashboard config
#k8s_resource('markedb', port_forwards="8080:8080", labels=['Frontend'])

# Automatically port forwarding the DB isn't possible until Zalando adds OwnerReferences
# https://github.com/zalando/postgres-operator/pull/2199
# use kubectl port-forward postgresql-0 5432 instead
#k8s_resource( objects=['postgresql:postgresql], new_name='postgresql', port_forwards="5432:5432", labels=['Backend'])
