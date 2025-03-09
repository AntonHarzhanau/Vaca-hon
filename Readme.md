# 🎲 Monopoly Multiplayer

## 📌 Description

A multiplayer online game **"Monopoly"**, developed using **Godot 4**. The server-side is implemented with **FastAPI (WebSockets)**.

## ⚡ Requirements

### 🎮 **Client (Godot 4)**

- **Godot 4.3+** (download from the [official website](https://godotengine.org/download))
- Operating System: **Windows / Linux**
- Internet connection (for online gameplay)

### 🖥 **Server (FastAPI)**

- **Python 3.9+**

---

## 🚀 Installation and Launch

### 🔹 **Starting the Server**

1. **Clone the repository** or download the source code:
    
```sh
git clone https://git.unistra.fr/s.berthelot/projet-integrateur-a6.git 
cd projet-integrateur-a6/server
```
    
2. **Create a virtual environment** (optional but recommended):
 ```sh
    python -m venv venv 
    source venv/bin/activate  # macOS/Linux 
    venv\Scripts\activate  # Windows`
```
    
    
3. **Upgrade pip**

```sh
	python.exe -m pip install --upgrade pip
```
      
    
4. **Install dependencies**:
    
```sh 
    pip install -r requirements.txt`
```
5. **Run the server**:
    
```sh
    uvicorn server2:app --host 0.0.0.0 --port 8000 --reload
```
> **Note:** Make sure that port **8000** is open for connections.
    
### 🔹 **Starting the Client (Godot 4)**

1. **Open Godot 4**.
2. **Import the project**:
    - Launch Godot 4 → Click **"Import"** → Select `project.godot` in the **client** folder.
3. **Run the game**:
    - In **Godot 4**, press **F5 (Run)** or click the ▶️ "Play" button.