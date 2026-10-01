# Fixtures

These are canned API responses for unit tests, UI tests, and SwiftUI previews.
Load them from a test bundle or package resources. Never fetch them from the
network.

> These files were written from the v4 API documentation, not captured from the
> live API. Verifying them against real responses is the "First task" in the
> assignment brief.

| File | HTTP | What it tests |
|---|---|---|
| `articles_page_1.json` | 200 | First page with `next` set. Dates with and without fractional seconds (`…07Z`, `…55.481000Z`, `…09.2Z`). Article 31009 has authors, `featured`, and a launch. |
| `articles_page_2.json` | 200 | Last page (`next: null`). **Article 31005 is repeated from page 1**, which simulates offset drift when a new article is published between requests. 10 items, 9 unique. |
| `articles_empty.json` | 200 | No results, for the search empty state. |
| `article_single.json` | 200 | `GET /v4/articles/{id}/` (deep links). Not wrapped in a page object. `updated_at` is later than `published_at`. |
| `articles_edge_cases.json` | 200 | Empty `image_url`, `authors`, and `summary`. A very long title and summary. Emoji and curly quotes. Arabic (right-to-left) text. A future date (clock skew). The Unix epoch. Untrimmed whitespace, HTML entities, and a URL containing spaces. |
| `articles_malformed.json` | 200 | One good item, one undecodable item (string `id`, `null` title, invalid date), and one good item with an **unknown extra field**. Decide and document whether a single bad item fails the whole page. |
| `error_404.json` | 404 | Deep link to an article that doesn't exist. |
| `error_429.json` | 429 | Rate limiting. Pair it with the response header `Retry-After: 30` in your `URLProtocol` stub. |
| `error_500.json` | 500 | A generic server error. |
| `error_502.html` | 502 | **Not JSON.** A proxy returned HTML. The client must not surface a decoding error as if it were the real problem. |

## Suggested stub setup

Write the `URLProtocol` stub yourself; that's part of the exercise. It should:

- route by request path and query (for example, `offset=5` returns page 2)
- set the status code and headers for each route
- optionally delay a response, so you can test stale search results and
  cancellation
- record every request it receives, so tests can assert on the number of calls
