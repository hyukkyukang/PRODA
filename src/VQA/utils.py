def is_alias(string_value: str) -> bool:
    return string_value.startswith("T") and "." in string_value and string_value.split(".")[0][1:].isdigit()

def remove_alias(string_value: str) -> str:
    return string_value.split(".")[1]