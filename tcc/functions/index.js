const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyNewEvent = functions.database
    .ref("/events/{eventId}") // caminho no Realtime Database
    .onCreate(async (snapshot, context) => {
      const event = snapshot.val();
      // Pegando todos os tokens dos usuários
      const tokensSnapshot =
    await admin.database().ref("/users").once("value");
      const tokens = [];
      tokensSnapshot.forEach((userSnap) => {
        const token = userSnap.child("token").val();
        if (token) tokens.push(token);
      });

      if (tokens.length === 0) return null;

      const message = {
        notification: {
          title: "Novo evento detectado",
          body: `Evento: ${event.name || "Um barulho"} foi registrado!`,
        },
        tokens: tokens,
      };

      return admin.messaging().sendMulticast(message);
    });
