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
SUPPORT_EMAIL = os.getenv("SUPPORT_EMAIL")

async def send_confirmation_email(to_email: str, username: str, code: str):
    msg = EmailMessage()
    msg["Subject"] = f"{username}, Welcome to Vacashon 🎲"
    msg["From"] = SMTP_SENDFROM
    msg["To"] = to_email
    msg["Reply-To"] = SMTP_SENDFROM
    msg["Message-ID"] = f"<{uuid.uuid4()}@vacashon.online>"

    msg.set_content(f"""
    Hi {username} 👋

    Thanks for signing up on Vacashon! 🎲

    To confirm your account, go into the game and enter this code:

    Confirmation code: {code}

    This code will expire in 24 hours.

    See you soon,  
    — The Vacashon Team
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
    msg["Subject"] = f"🔐 Your reset password code : {reset_code}"
    msg["From"] = SMTP_SENDFROM
    msg["To"] = to_email
    msg["Reply-To"] = SMTP_SENDFROM
    msg["Message-ID"] = f"<{uuid.uuid4()}@vacashon.online>"

    msg.set_content(f"""
    Hi 👋

    Here is your reset code:  
    ➡️ {reset_code}

    If you didn’t request this, you can safely ignore this message.

    See you soon on the board! 🎲  
    — The Vacashon Team
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
    msg["To"] = SUPPORT_EMAIL
    msg["Reply-To"] = email
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

        print(f"✅ Email envoyé à '{SUPPORT_EMAIL}'")

        return True
    except Exception as e:
        print(f"❌ Erreur lors de l'envoi de l'email : {e}")
        return False