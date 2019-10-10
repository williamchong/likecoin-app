import URL from "url-parse"

/**
 * Process the URL for different domains
 * 
 * @param urlString The deeplink URL
 */
export function parseDeeplinkURL(urlString: string) {
  const url = new URL(urlString, true)

  switch (url.hostname) {
    case "oice.com":
      url.query.__oiceApp__ = "true"
      break
  }

  return url.toString()
}