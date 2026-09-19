import bcrypt


def hash_password(password: str) -> str:
    password_bytes = password.encode("utf-8")

    hashed_password = bcrypt.hashpw(
        password_bytes,
        bcrypt.gensalt(),
    )

    return hashed_password.decode("utf-8")


def verify_password(
    plain_password: str,
    password_hash: str,
) -> bool:
    password_bytes = plain_password.encode("utf-8")
    password_hash_bytes = password_hash.encode("utf-8")

    return bcrypt.checkpw(
        password_bytes,
        password_hash_bytes,
    )