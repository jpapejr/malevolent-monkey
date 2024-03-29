#!/bin/bash
echo "$(date) Booting and using $APISERVER for $TTL cycles of $INTERVAL seconds"

if [ ! -f /var/run/secrets/kubernetes.io/serviceaccount/token ]; then
        echo "$(date) Detected Kubernetes environment, using mounted service account token"
        TOKEN=$TOKEN
else
        echo "$(date) Using provided token"
        TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`
fi

RESOURCES=$(kubectl get $TARGETRESOURCE -n $NAMESPACE --insecure-skip-tls-verify=true --token $TOKEN --server $APISERVER | grep -v NAME | cut -d" " -f1)
COUNT=0

for r in $RESOURCES; do
        COUNT=$(($COUNT+1))
done

for (( c=0; c<$TTL; c++ )); do 
        DIV=$(($COUNT))
        R=$(($RANDOM%$DIV))

        TARGET=$(kubectl get pods -n $NAMESPACE --insecure-skip-tls-verify=true --token $TOKEN --server $APISERVER -o jsonpath="{.items[$R].metadata.name}")
        echo "$(date) Starting cycle $((c+1)) " 
        echo "$(date) Selected resource -> $TARGET for $ACTION"
        echo "$(date) $(kubectl delete $TARGETRESOURCE $TARGET -n $NAMESPACE --insecure-skip-tls-verify=true --token $TOKEN --server $APISERVER) "
        echo "$(date) Sleeping $INTERVAL seconds..." 
        sleep $INTERVAL
done

echo "$(date) Last cycle completed, halting.."
