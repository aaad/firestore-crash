
CALL gcloud config set project testing-profile-crawler
CALL gcloud builds submit --tag gcr.io/testing-profile-crawler/firestore-crash