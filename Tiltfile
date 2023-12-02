allow_k8s_contexts("kind-kind")

# Build main app with live_update enabled
docker_build('markedb', 'backend',
    dockerfile="backend/Dockerfile",
    live_update=[

    ],
)

# Deploy app
k8s_yaml(kustomize('deploy/kubernetes/local-dev'))

# Tilt dashboard config
#k8s_resource('markedb', port_forwards="8080:8080")
#k8s_resource('postgresql', port_forwards="5432:5432")
