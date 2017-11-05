use curl
import text/json/DSL into JSON
import curl/Highlevel

BASE_URL := "https://slack.com/api/"
USER_PROFILE_GET_PATH := "users.profile.get"
USER_PROFILE_SET_PATH := "users.profile.set"

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

    getUserProfile: func -> String {
        url := "#{BASE_URL}#{USER_PROFILE_GET_PATH}?token=#{token}"
        handle := HTTPRequest new(url)
        handle perform()

        return handle getString()
    }

    setUserProfile: func (text, emoji: String)  -> String {
        handle := HTTPRequest new(BASE_URL + USER_PROFILE_SET_PATH)
        data := FormData new()
        data addField(TOKEN, token)
        data addField(PROFILE, getPayload(text, emoji))

        handle setFormData(data)
        handle perform()
        return handle getString()
    }
}
