import requests
import os
import time

# =========================
# CONFIG
# =========================
PEXELS_API_KEY = "7ung7nXcejY9GaWte3llxs1vUcT0MUFDEVH0dF6QYX8AQhz30SdJ8LxD"
OUTPUT_DIR = "downloaded_images"

os.makedirs(OUTPUT_DIR, exist_ok=True)

# =========================
# JORDAN CULTURE BIAS ENGINE
# =========================
def jordanize_query(description: str) -> str:
    """
    Expands query to bias results toward Jordanian culture.
    """
    jordan_keywords = [
        "Jordan", "Amman", "Petra", "Wadi Rum",
        "Bedouin", "Middle Eastern", "Arabic culture",
        "Hashemite", "Jordanian street"
    ]

    # Heuristic: append cultural context
    return f"{description} in Jordan, {', '.join(jordan_keywords[:3])}"

# =========================
# SEARCH IMAGES
# =========================
def search_images(query, per_page=3):
    url = "https://api.pexels.com/v1/search"

    headers = {
        "Authorization": PEXELS_API_KEY
    }

    params = {
        "query": query,
        "per_page": per_page
    }

    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status()

    return response.json()["photos"]

# =========================
# DOWNLOAD IMAGE
# =========================
def download_image(img_url, filename):
    img_data = requests.get(img_url).content
    with open(filename, "wb") as f:
        f.write(img_data)

# =========================
# MAIN PROCESS
# =========================
def process_descriptions(descriptions):
    for i, desc in enumerate(descriptions):
        print(f"\n[INFO] Processing: {desc}")

        query = jordanize_query(desc)
        print(f"[SEARCH QUERY] {query}")

        try:
            results = search_images(query)

            for j, img in enumerate(results):
                img_url = img["src"]["large"]
                filename = os.path.join(OUTPUT_DIR, f"img_{i}_{j}.jpg")

                download_image(img_url, filename)
                print(f"[DOWNLOADED] {filename}")

                time.sleep(0.5)

        except Exception as e:
            print(f"[ERROR] {e}")


# =========================
# INPUT LIST
# =========================
if __name__ == "__main__":
    descriptions = [
        "traditional marketplace",
        "desert landscape at sunset",
        "street food vendor",
        "ancient ruins on hill"
    ]

    process_descriptions(descriptions)