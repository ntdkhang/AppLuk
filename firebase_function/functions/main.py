# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import firestore_fn
import firebase_admin
from firebase_admin import db, firestore, messaging

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
    db = firestore.client(app)

    fromUser = db.collection("users").document(fromId).get().to_dict()
    token = db.collection("fcmTokens").document(toId).get()

    # Query for an opposite friend request
    docs = db.collection("friendRequests").where("fromId", "==", toId).where("toId", "==", fromId)
    count = docs.count().get()[0][0].value
    if count > 0:
        otherDoc = db.collection("users").document(toId)
        otherDoc.update({"friendsId": firestore.firestore.ArrayUnion([fromId])})

        myDoc = db.collection("users").document(fromId)
        myDoc.update({"friendsId": firestore.firestore.ArrayUnion([toId])})

        # Send notification to say that user accepted your friend request
        if token.exists:
            token_dict = token.to_dict()
            if token_dict != None and fromUser != None:
                fcm_token = token_dict["token"]
                notification = messaging.Notification(
                        title="Friend request accepted",
                        body=f"{fromUser["name"]} accepted your friend request",
                        )
                msg = messaging.Message(token=fcm_token, notification=notification)
                response: messaging.BatchResponse = messaging.send(msg)
                if response.failure_count < 1:
                    # Sucess!
                    return

    else:
        # Send notification to say that user sent a friend request
        if token.exists:
            token_dict = token.to_dict()
            if token_dict != None and fromUser != None:
                fcm_token = token_dict["token"]
                notification = messaging.Notification(
                        title="New friend request",
                        body=f"{fromUser["name"]} sent a friend request",
                        )
                msg = messaging.Message(token=fcm_token, notification=notification)
                response: messaging.BatchResponse = messaging.send(msg)
                if response.failure_count < 1:
                    # Sucess!
                    return


