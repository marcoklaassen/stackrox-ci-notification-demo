export ROX_CENTRAL_PASSWORD=$(oc get secret central-htpasswd -n rhacs --template={{.data.password}} | base64 -d)
export ROX_CENTRAL_HOST=$(oc get route central -n rhacs --template={{.spec.host}})
curl 'https://'$ROX_CENTRAL_HOST'/v1/notifiers' \
    -H 'content-type: application/json' \
    -u 'admin:'$ROX_CENTRAL_PASSWORD \
    --data-binary '@acs-install/slack-post.json' \
    --compressed \
    --insecure
