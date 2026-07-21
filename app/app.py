import os
from datetime import UTC, datetime

from flask import Flask, jsonify, render_template


def create_app() -> Flask:
    app = Flask(__name__)

    @app.get("/")
    def index():
        return render_template(
            "index.html",
            environment=os.getenv("APP_ENV", "development"),
            version=os.getenv("APP_VERSION", "local"),
        )

    @app.get("/health")
    def health():
        return jsonify(
            status="healthy",
            service="cloud-status-dashboard",
            timestamp=datetime.now(UTC).isoformat(),
        )

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))
