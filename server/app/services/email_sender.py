import os
from dotenv import load_dotenv
from email.message import EmailMessage
from app.schemas.user_schema import UserSupportRequestSchema
import uuid
import aiosmtplib

# Load environment variables from .env
load_dotenv() 

# Infos SMTP

SMTP_HOST = os.getenv("SMTP_HOST")
SMTP_PORT = os.getenv("SMTP_PORT")
EMAIL_ADDRESS = os.getenv("SMTP_USER")
EMAIL_PASSWORD = os.getenv("SMTP_PASSWORD")
SMTP_SENDFROM = os.getenv("SMTP_SENDFROM")

async def send_confirmation_email(to_email: str, username: str, code: str):
    msg = EmailMessage()
    msg["Subject"] = f"{username}, bienvenue dans l'aventure Vacashon 🎲"
    msg["From"] = SMTP_SENDFROM
    msg["To"] = to_email
    msg["Reply-To"] = SMTP_SENDFROM
    msg["Message-ID"] = f"<{uuid.uuid4()}@vacashon.online>"

    msg.set_content(f"""
    Salut {username} 👋

    Merci pour ton inscription sur Vacashon ! 🎲

    Pour confirmer ton compte, rends-toi dans le jeu et saisis ce code :

    Code de confirmation : {code}

    Ce code expire dans 24 heures.

    À très vite,
    — L’équipe Vacashon
    """)

    try:
        # Création d'une instance SMTP
        smtp = aiosmtplib.SMTP(hostname=SMTP_HOST, port=SMTP_PORT, start_tls=True)
        await smtp.connect()
        await smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        await smtp.send_message(msg)
        await smtp.quit()

        print(f"✅ Email envoyé à {to_email}")
    except Exception as e:
        print(f"❌ Erreur lors de l'envoi de l'email : {e}")

async def send_reset_email(to_email: str, reset_code: str):
    msg = EmailMessage()
    msg["Subject"] = f"🔐 Code de réinitialisation : {reset_code}"
    msg["From"] = SMTP_SENDFROM
    msg["To"] = to_email
    msg["Reply-To"] = SMTP_SENDFROM
    msg["Message-ID"] = f"<{uuid.uuid4()}@vacashon.online>"

    msg.set_content(f"""
    Salut 👋

    Tu as demandé à réinitialiser ton mot de passe pour Vacashon.

    Voici ton code de réinitialisation :
    ➡️ {reset_code}

    Si tu n'es pas à l'origine de cette demande, tu peux ignorer ce message.

    À très vite sur le plateau ! 🎲  
    — L’équipe Vacashon
    """)

    try:
        # Création d'une instance SMTP
        smtp = aiosmtplib.SMTP(hostname=SMTP_HOST, port=SMTP_PORT, start_tls=True)
        await smtp.connect()
        await smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        await smtp.send_message(msg)
        await smtp.quit()

        print(f"✅ Email envoyé à {to_email}")
    except Exception as e:
        print(f"❌ Erreur lors de l'envoi de l'email : {e}")

async def send_support_email(support_payload: UserSupportRequestSchema):
    """
    Sends email to 'support@vacashon.email' when Support form is submitted from client
    """
    
    # Check if user's email is not empty
    username = support_payload.username
    email = support_payload.email
    phone = support_payload.phone
    rating = support_payload.rating
    message = support_payload.message


    # Payload validattion
    if not email and email == "":
        return
    
    # Setup Email to send
    msg = EmailMessage()
    msg["Subject"] = f"Support Request from : {email}"
    msg["From"] = SMTP_SENDFROM
    msg["To"] = "support@vacashon.online"
    msg["Reply-To"] = SMTP_SENDFROM
    msg["Message-ID"] = f"<{uuid.uuid4()}@vacashon.online>"

    msg.set_content(f"""
    Hello,
                    
    A new Support Request has been submitted by a player :
                    
    - Username : {username}
    - Email : {email}
    - Phone number : {phone}
    - Rating : {rating}
    - Message :  {message}

    Thank you.
    — Vacashon Game
    """)

    try:
        # Création d'une instance SMTP
        smtp = aiosmtplib.SMTP(hostname=SMTP_HOST, port=SMTP_PORT, start_tls=True)
        await smtp.connect()
        await smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        await smtp.send_message(msg)
        await smtp.quit()

        print(f"✅ Email envoyé à 'support@vacashon.online'")
    except Exception as e:
        print(f"❌ Erreur lors de l'envoi de l'email : {e}")