export ROX_CENTRAL_PASSWORD=$(oc get secret central-htpasswd -n stackrox --template={{.data.password}} | base64 -d)
export ROX_CENTRAL_ADDRESS=$(oc get route central -n stackrox --template=https://{{.spec.host}}:443)
roxctl -e "$ROX_CENTRAL_ADDRESS" central init-bundles generate ocp4 --output-secrets ocp4-init-bundle.yaml --password "$ROX_CENTRAL_PASSWORD"
oc apply -f ocp4-init-bundle.yaml -n stackrox
rm ocp4-init-bundle.yaml
