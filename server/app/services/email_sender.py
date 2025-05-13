import smtplib
from email.message import EmailMessage
import uuid
import aiosmtplib

# Infos SMTP
SMTP_HOST = "mail.vacashon.online"
SMTP_PORT = 587
EMAIL_ADDRESS = "contact@vacashon.online"
EMAIL_PASSWORD = "N(68&:HH8b34"  # ⚠️ ne jamais le laisser exposé publiquement

async def send_confirmation_email(to_email: str, username: str, code: str):
    msg = EmailMessage()
    msg["Subject"] = f"{username}, bienvenue dans l'aventure Monopoly 🎲"
    msg["From"] = EMAIL_ADDRESS
    msg["To"] = to_email
    msg["Reply-To"] = EMAIL_ADDRESS
    msg["Message-ID"] = f"<{uuid.uuid4()}@vacashon.online>"

    msg.set_content(f"""
    Salut {username} 👋

    Merci pour ton inscription sur Monopoly ! 🎲

    Pour confirmer ton compte, rends-toi dans le jeu et saisis ce code :

    Code de confirmation : {code}

    Ce code expire dans 24 heures.

    À très vite,
    — L’équipe Monopoly
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
    msg["From"] = EMAIL_ADDRESS
    msg["To"] = to_email
    msg["Reply-To"] = EMAIL_ADDRESS
    msg["Message-ID"] = f"<{uuid.uuid4()}@vacashon.online>"

    msg.set_content(f"""
    Salut 👋

    Tu as demandé à réinitialiser ton mot de passe pour Monopoly.

    Voici ton code de réinitialisation :
    ➡️ {reset_code}

    Si tu n'es pas à l'origine de cette demande, tu peux ignorer ce message.

    À très vite sur le plateau ! 🎲  
    — L’équipe Monopoly
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
