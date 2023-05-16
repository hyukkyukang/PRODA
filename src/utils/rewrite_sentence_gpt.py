import openai


def set_openai(APIKEY="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", ORGANID="org-YauJu6foTOJVOkod2jhcOwNq"):
    openai.organization = ORGANID
    openai.api_key = APIKEY


def rewrite_sentence(text):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo", messages=[{"role": "user", "content": text}], temperature=0
    )
    return response["choices"][0]["message"]["content"].strip()
