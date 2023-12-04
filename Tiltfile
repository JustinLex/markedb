allow_k8s_contexts("kind-kind")

# Build datatype bindings for frontend
local_resource (name='datatype-bindings',
                cmd='./build-datatype-bindings.sh',
                deps = 'backend/',
                allow_parallel = True,
                labels = ['Frontend'])

# Full app stack with hot-reloading
docker_build('markedb-backend', 'backend',
    dockerfile='backend/Dockerfile',
    # Not possible to hot reload a scratch container without local compilation
)
docker_build('markedb-nginx', 'frontend',
    dockerfile='frontend/dockerfiles/nginx.Dockerfile',
    live_update=[
        sync('frontend/public', '/var/www'),
        sync('frontend/', '/tmp'),  # Ignore CSR changes, js modules are served by remix dev server
    ],
)
docker_build('markedb-frontend-remix-dev', 'frontend',
    dockerfile='frontend/dockerfiles/remix.Dockerfile',
    target='development',
    live_update=[
        fall_back_on('frontend/composer.json'),
        fall_back_on('frontend/composer.lock'),
        sync('frontend/', '/app'),
    ],
)

# Production express-ssr container for testing production loading
docker_build('markedb-frontend-remix', 'frontend',
    dockerfile='frontend/dockerfiles/remix.Dockerfile',
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
# TODO install gateway API and istio for routing/proxying
# routes:
# /build/ to nginx
# /api/v1/ to backend
# /favicon.ico to nginx
# / to frontend-ssr

# Deploy app
k8s_yaml(kustomize('deploy/kubernetes/local-dev'))

# Tilt dashboard config
k8s_resource('backend', port_forwards="8080:8080", labels=['Backend'])
k8s_resource('express-ssr-dev', port_forwards="3000:3000", labels=['Frontend'])
k8s_resource('nginx', port_forwards="8081:8080", labels=['Frontend'])

# Prod SSR container, disabled by default, no hot-reloading
k8s_resource('express-ssr', new_name='express-ssr-prod', port_forwards="3001:3000", auto_init=False, trigger_mode=TRIGGER_MODE_MANUAL, labels=['Frontend'])

# Automatically port forwarding the DB isn't possible until Zalando adds OwnerReferences
# https://github.com/zalando/postgres-operator/pull/2199
# use kubectl port-forward postgresql-0 5432 instead
k8s_resource( objects=['postgresql:postgresql'], new_name='postgresql', resource_deps=['zalando-pgo'], labels=['Backend'])
