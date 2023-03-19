import openai


def set_openai(APIKEY="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", ORGANID="org-YauJu6foTOJVOkod2jhcOwNq"):
    openai.organization = ORGANID
    openai.api_key = APIKEY


def templatize(history, current):
    text = ""
    refer_text = []
    for i, sentence in enumerate(history):
        text += " Q" + str(i + 1) + " is to " + sentence
        refer_text.append("Q" + str(i + 1))

    cur_idx = len(history) + 1
    text += " Q" + str(cur_idx) + " is to " + current

    text += " Write out Q" + str(cur_idx) + " in a sentence by referring to " + ", ".join(refer_text) + "."
    # print(text)

    return text


def rewrite_sentence(text):
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo", messages=[{"role": "user", "content": text}], temperature=0
    )
    return response["choices"][0]["message"]["content"].strip()
