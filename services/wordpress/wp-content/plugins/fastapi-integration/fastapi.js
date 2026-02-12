document.addEventListener("DOMContentLoaded", async () => {

    if (typeof fastapiData === "undefined") return;

    const postId = fastapiData.postId;
    const apiBase = fastapiData.apiUrl;

    const article = document.querySelector("article");
    if (!article) return;

    const container = document.createElement("div");
    container.innerHTML = `
        <hr>
        <h3>❤️ Likes</h3>
        <button id="likeBtn">Like</button>
        <p id="likeCount">Loading...</p>

        <hr>
        <h3>💬 Comments</h3>
        <div id="comments"></div>

        <textarea id="commentInput" placeholder="Write a comment"></textarea>
        <button id="commentBtn">Post Comment</button>
    `;

    article.appendChild(container);

    async function loadLikes() {
        try {
            const res = await fetch(`${apiBase}/likes/post/${postId}`);
            if (!res.ok) throw new Error("API error");
            const data = await res.json();
            document.getElementById("likeCount").innerText =
                `Likes: ${data.likes}`;
        } catch (err) {
            document.getElementById("likeCount").innerText =
                "Error loading likes";
        }
    }

    async function loadComments() {
        try {
            const res = await fetch(`${apiBase}/comments/post/${postId}`);
            if (!res.ok) throw new Error("API error");

            const data = await res.json();
            const commentsDiv = document.getElementById("comments");
            commentsDiv.innerHTML = "";

            data.forEach(comment => {
                const p = document.createElement("p");
                p.innerText = comment.content;
                commentsDiv.appendChild(p);
            });

        } catch (err) {
            document.getElementById("comments").innerText =
                "Error loading comments";
        }
    }

    document.getElementById("likeBtn").addEventListener("click", async () => {
        try {
            await fetch(`${apiBase}/likes`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ post_id: postId })
            });
            loadLikes();
        } catch (err) {
            alert("Error sending like");
        }
    });

    document.getElementById("commentBtn").addEventListener("click", async () => {
        const content = document.getElementById("commentInput").value.trim();
        if (!content) return;

        try {
            await fetch(`${apiBase}/comments`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ post_id: postId, content })
            });

            document.getElementById("commentInput").value = "";
            loadComments();

        } catch (err) {
            alert("Error posting comment");
        }
    });

    loadLikes();
    loadComments();
});
