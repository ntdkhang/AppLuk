# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import firestore_fn
import firebase_admin
from firebase_admin import firestore, messaging
from google.cloud.firestore_v1.base_query import FieldFilter


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
    docs = db.collection("friendRequests").where(filter=FieldFilter("fromId", "==", toId)).where(filter=FieldFilter("toId", "==", fromId))
    count = docs.count().get()[0][0].value
    if count > 0:
        otherDoc = db.collection("users").document(toId)
        otherDoc.update({"friendsId": firestore.firestore.ArrayUnion([fromId])})

        myDoc = db.collection("users").document(fromId)
        myDoc.update({"friendsId": firestore.firestore.ArrayUnion([toId])})

        event.data.reference.delete()
        docs.get()[0].reference.delete()

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
                messaging.send(msg)

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
                messaging.send(msg)



@firestore_fn.on_document_created(document="knowledges/{knowledgeId}/comments/{commentId}")
def newCommentNoti(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    db = firestore.client(app)

    if event.data is None:
        return
    newComment = event.data.to_dict()
    if newComment is None:
        return
    commenterId = newComment["postedById"]
    commenter = db.collection("users").document(commenterId).get().to_dict()


    knowledgeId = event.params["knowledgeId"]
    knowledge = db.collection("knowledges").document(knowledgeId).get().to_dict()
    # knowledge = knowledgeRef.to_dict()
    if knowledge is not None:
        knowledgeOnwerId = knowledge["postedById"]

        # notify KNOWLEDGE OWNER
        token = db.collection("fcmTokens").document(knowledgeOnwerId).get()
        if token.exists:
            token_dict = token.to_dict()
            if token_dict is not None and commenterId != knowledgeOnwerId and commenter is not None:
                fcm_token = token_dict["token"]
                notification = messaging.Notification(
                        title="New comment",
                        body=f"{commenter["name"]} commented on your post",
                        )
                msg = messaging.Message(token=fcm_token, notification=notification)
                messaging.send(msg)

        # Notify all users who commented on this post
        idsToSend = []
        comments = db.collection("knowledges").document(knowledgeId).collection("comments").stream()
        for comment in comments:
            id = comment.to_dict()["postedById"]
            if id not in idsToSend and id != knowledgeOnwerId and id != commenterId:
                token = db.collection("fcmTokens").document(id).get()
                if token.exists:
                    token_dict = token.to_dict()
                    if token_dict is not None and commenter is not None:
                        fcm_token = token_dict["token"]
                        notification = messaging.Notification(
                                title="New comment",
                                body=f"{commenter["name"]} commented on a post you interacted with",
                                )
                        msg = messaging.Message(token=fcm_token, notification=notification)
                        messaging.send(msg)


