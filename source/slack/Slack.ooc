use curl
import curl/Highlevel
import text/json
import text/json/DSL into DSL
import structs/HashBag
import slack/Status

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

    getStatus: func (json: String) -> Status {
        root := JSON parse(json)
        profile := root get("profile", HashBag)
        text := profile get("status_text", String)
        emoji := profile get("status_emoji", String)
        return Status new(text, emoji)
    }

    getPayload: func (text, emoji: String) -> String {
        return DSL make(|j|
            j object(
                STATUS_TEXT, text,
                STATUS_EMOJI, emoji
            )
        )
    }

    getUserProfile: func -> Status {
        url := "#{BASE_URL}#{USER_PROFILE_GET_PATH}?token=#{token}"
        handle := HTTPRequest new(url)
        handle perform()

        return getStatus(handle getString())
    }

    setUserProfile: func (text, emoji: String) -> Status {
        handle := HTTPRequest new(BASE_URL + USER_PROFILE_SET_PATH)
        data := FormData new()
        data addField(TOKEN, token)
        data addField(PROFILE, getPayload(text, emoji))

        handle setFormData(data)
        handle perform()
        return getStatus(handle getString())
    }
}
