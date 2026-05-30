let selectedConversationId = null;

/* =========================
   SAFE OPEN/CLOSE WIDGET
========================= */
const fab = document.getElementById("chat-fab");

if (fab) {
    fab.onclick = async function () {
        const panel = document.getElementById("chat-panel");

        if (panel.style.display === "none" || panel.style.display === "") {
            panel.style.display = "flex";
            await loadConversations();
        } else {
            panel.style.display = "none";
        }
    };
}

/* =========================
   LOAD CONVERSATIONS
========================= */
async function loadConversations() {
    const res = await fetch("/Chat/GetConversations");
    const data = await res.json();

    const list = document.getElementById("conversation-list");
    list.innerHTML = "";

    data.forEach(c => {
        const div = document.createElement("div");
        div.className = "conversation-item";

        div.innerHTML = `
            <strong>${c.otherUserName}</strong><br/>
            <small>${c.lastMessage ?? ""}</small>
        `;

        div.onclick = () => openChat(c.conversationId, c.otherUserName);

        list.appendChild(div);
    });
}

/* =========================
   OPEN CHAT
========================= */
async function openChat(id, name) {
    selectedConversationId = id;

    document.getElementById("chat-conversations").style.display = "none";
    document.getElementById("chat-window").style.display = "flex";

    document.getElementById("chat-with-name").innerText = name;

    await loadMessages();
}

/* =========================
   LOAD MESSAGES
========================= */
async function loadMessages() {
    if (!selectedConversationId) return;

    const res = await fetch(`/Chat/GetMessages?conversationId=${selectedConversationId}`);
    const data = await res.json();

    const box = document.getElementById("chat-messages");
    box.innerHTML = "";

    data.forEach(m => {
        const div = document.createElement("div");

        div.className = "message " + (m.isMine ? "me" : "other");
        div.innerText = m.text;

        box.appendChild(div);
    });

    box.scrollTop = box.scrollHeight;
}

/* =========================
   SEND MESSAGE
========================= */
const sendBtn = document.getElementById("send-message");

if (sendBtn) {
    sendBtn.onclick = async function () {

        const input = document.getElementById("message-input");
        const text = input.value.trim();

        if (!text || !selectedConversationId) return;

        await fetch("/Chat/Send", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: `conversationId=${selectedConversationId}&text=${text}`
        });

        input.value = "";

        await loadMessages();
    };
}

/* =========================
   CLOSE CHAT WINDOW
========================= */
const closeBtn = document.getElementById("close-chat");

if (closeBtn) {
    closeBtn.onclick = function () {
        document.getElementById("chat-window").style.display = "none";
        document.getElementById("chat-conversations").style.display = "block";
        loadConversations();
    };
}

/* =========================
   START CONVERSATION (FROM MENTOR CARD)
========================= */
document.addEventListener("DOMContentLoaded", function () {

    console.log("Chat JS Ready");

    document.querySelectorAll(".start-chat-btn").forEach(btn => {
        btn.addEventListener("click", async function () {

            console.log("Message Mentor clicked");

            const mentorId = this.dataset.mentorId;

            const res = await fetch("/Chat/StartConversation", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `mentorId=${mentorId}`
            });

            const data = await res.json();

            document.getElementById("chat-panel").style.display = "flex";

            await loadConversations();

            openChat(data.conversationId, "Mentor");
        });
    });

});