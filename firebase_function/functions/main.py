# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import firestore_fn
import firebase_admin
from firebase_admin import db, firestore

app = firebase_admin.initialize_app()


@firestore_fn.on_document_created(document="friendRequests/{requestId}")
def addFriend(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    if event.data is None:
        return
    try:
        fromId = event.data.get("fromId")
        toId = event.data.get("toId")
    except KeyError:
        return
    """
     Query friend requests to see if the other way exists?
     If no:
         Send friend request notification
     If yes:
         Add friends
         Send notification for friend accept

    """


    cloudDb = firestore.client(app)
    otherDoc = cloudDb.collection("users").document(toId)
    otherDoc.update({"friendsId": firestore.firestore.ArrayUnion([fromId])})

    myDoc = cloudDb.collection("users").document(fromId)
    myDoc.update({"friendsId": firestore.firestore.ArrayUnion([toId])})
