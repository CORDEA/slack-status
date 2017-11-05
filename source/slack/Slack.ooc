use curl
import text/json/DSL into JSON
import curl/Highlevel

BASE_URL := "https://slack.com/api/"
USER_PROFILE_PATH := "users.profile.set"

PROFILE := "profile"
STATUS_TEXT := "status_text"
STATUS_EMOJI := "status_emoji"
TOKEN := "token"

Slack: class {
    token: String

    init: func (=token)

    getPayload: func (text, emoji: String) -> String {
        return JSON make(|j|
            j object(
                STATUS_TEXT, text,
                STATUS_EMOJI, emoji
            )
        )
    }

    setUserProfile: func (text, emoji: String)  -> String {
        handle := HTTPRequest new(BASE_URL + USER_PROFILE_PATH)
        data := FormData new()
        data addField(TOKEN, token)
        data addField(PROFILE, getPayload(text, emoji))

        handle setFormData(data)
        handle perform()
        return handle getString()
    }
}
