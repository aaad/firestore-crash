# firestore-crash

Question can be found on https://stackoverflow.com/questions/58613778/uncaught-signal-11-when-using-net-core-cloud-firestore-in-google-cloud?noredirect=1

## How to reproduce?

* First execute:

```
gcloud config set project <your-project-name>
gcloud builds submit --tag gcr.io/<your-project-name>/firestore-crash
```

* Deploy new service in Cloud Run without authentification.
* Execute https://insert-deployed-service-name.run.app/test

-> Service Unavailable                                                                            
-> Logs: "Uncaught signal: 11, pid=1, tid=18, fault_addr=453942."

## Tried

Changed mcr.microsoft.com/dotnet/core/aspnet:3.0.0-alpine to 3.0.0-buster-slim and mcr.microsoft.com/dotnet/core/sdk:3.0-buster + removed apk add --no-cache libc6-compat and ln -s /lib/ld-musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2
-> Also not working

## What works?

* Deploy the docker container locally by using

```
docker build -t firestore-crash .
CALL docker run -p 12615:12615 crawler-collector
```

Also set GOOGLE_APPLICATION_CREDENTIALS in the docker container.

-> http://localhost:12655/test works.
