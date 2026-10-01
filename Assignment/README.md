# Take-Home Assignment: SpaceFlight (Senior iOS Engineer)

## Context

You're joining a small team that is building a news reader for spaceflight
enthusiasts. Your job is the first version of the iOS client. This repo will be
the base for future features, and other engineers will build on it.
**We care more about the foundation than the feature count.**

We'll read your code the way we'd review a teammate's pull request. Then we'll
spend an hour with you discussing the decisions you made. The panel questions
are listed at the end of [EVALUATION.md](EVALUATION.md).

- **Timebox:** Aim for roughly 10–12 focused hours. If you go over, stop and use
  the README to describe what you would do next. We value judgment about scope
  more than completeness.
- **Where to work:** Create a new Xcode project in a sibling folder (for example,
  `SpaceFlight2/`). Don't modify the 2021 project. You'll compare the two at the
  end.

---

## The API

Use the [Spaceflight News API v4](https://api.spaceflightnewsapi.net/v4/docs/).

| Endpoint | Use |
|---|---|
| `GET /v4/articles/?limit=20&offset=0` | Paginated feed |
| `GET /v4/articles/?search=<term>&limit=20` | Search |
| `GET /v4/articles/{id}/` | Single article (used for deep links) |

List responses are wrapped in a page object: `{ count, next, previous, results }`.

> **First task:** Hit the live API and compare its responses with the files in
> [`Fixtures/`](Fixtures/). Our fixtures were written from the documentation and
> may be out of date. If the schema doesn't match, update the fixtures and record
> the difference in your README. A senior engineer checks the contract before
> building on it.

---

## Functional requirements

Design mocks are in [`Mocks/screens.html`](Mocks/screens.html). Open it in a
browser. Treat the mocks as design intent, not a pixel spec.

### F1 — Feed
- Show a list of articles, newest first. Each row shows the thumbnail, news site,
  title (up to 3 lines), and a relative publish time ("2h ago").
- **Infinite scroll:** Load the next page when the user nears the end. Never
  request the same page twice at once.
- **Pull to refresh.**
- **Deduplicate.** The API uses offset pagination, so if new articles are
  published while the user scrolls, an article can appear on two pages. The UI
  must never show duplicates and must never crash because of them. The fixtures
  include this case.

### F2 — Search
- Add a search field on the feed.
- Debounce input by about 300 ms.
- Typing must cancel any request that is still in flight. Results from an older
  query must never replace results from a newer one.
- Show a distinct empty state when a search has no results.

### F3 — Article detail
- Show the hero image, news site, date, authors (if any), title, and summary.
- **Read full article** opens the URL in an in-app browser
  (`SFSafariViewController`).
- **Share** uses `ShareLink`.
- **Bookmark** toggles in the toolbar.

### F4 — Saved articles
- Add a second tab listing bookmarked articles, newest bookmark first.
- Bookmarks persist across app launches and work fully **offline**: the saved
  article and its image are readable with no network.
- Swipe to delete.

### F5 — Offline and failure behavior
- Persist the most recent first page of the feed. On launch with no network,
  show the cached articles with a non-blocking "You're offline" banner.
- If the first load fails, show a full-screen error with **Retry**.
- If loading a later page fails, show an inline row with **Retry**. The articles
  already loaded stay on screen.
- **429 Too Many Requests:** Respect `Retry-After` when present. Don't hammer
  the API.

### F6 — Deep link
- `spaceflight://article/{id}` opens that article's detail, from a cold start
  or while the app is running.
- If the article isn't in memory, fetch it.
- If it doesn't exist (404), show an appropriate message rather than an empty
  screen.

### F7 — iPad
- On regular width, use a two-column layout (`NavigationSplitView`): list on the
  left, detail on the right, with a sensible placeholder when nothing is selected.

---

## Technical requirements

These are **requirements, not suggestions**. If you deviate from one, explain
why in your README.

### Platform
- Target iOS 17 or later, Swift 6 language mode, **complete strict concurrency
  checking**, **zero warnings**.
- Use SwiftUI and the Observation framework (`@Observable`). UIKit is fine
  wherever it's the better tool; say where you used it and why.
- **No third-party dependencies.** If you think one is warranted, argue for it
  in the README instead of adding it.

### Architecture
- Organize the code into **at least two local Swift packages**, for example a
  core package for models, networking, and persistence, and a features package
  for UI.
- The app target should contain little more than composition and app lifecycle.
- Dependencies are **injected**. No view model reaches for a singleton.
- The networking layer must provide:
  - a typed error model (transport, HTTP status, decoding, cancelled)
  - configurable timeouts
  - async and cancellable requests
  - no blocking calls such as `DispatchSemaphore` or `.wait()`
- Decoding is tolerant where the real world is messy and strict where
  correctness matters. Document which fields fall into which category.

### Images
- Build your own small image pipeline rather than relying only on `AsyncImage`.
  It must:
  - cache in memory and on disk
  - **coalesce** concurrent requests for the same URL into one network call
  - downsample to display size before decoding into memory
  - cancel loads for rows that scroll off screen
- An `actor` is the expected tool. Be ready to discuss actor reentrancy.

### Persistence
- Use SwiftData or files plus `Codable`. Your choice, but justify it.
- Never leave template code you don't use, such as an empty Core Data stack.

### Quality
- **Accessibility:**
  - Dynamic Type through accessibility sizes (AX5) without truncating critical
    content
  - meaningful VoiceOver labels; combine each row into a single element
  - respect Reduce Motion
- **Localization-ready:**
  - all user-facing strings in a String Catalog
  - dates formatted with `FormatStyle` or `RelativeDateTimeFormatter`; no
    hand-written date format strings in UI code
- Use `os.Logger` with categories. No `print`.
- Never decode JSON or images on the main actor.

### Testing
- Use **Swift Testing** (`@Test`, `#expect`) for unit tests.
- **Test the real types.** Mocks replace *dependencies* of the system under test,
  never the system under test itself.
- Required coverage:
  - decoding every file in `Fixtures/`, including the malformed ones
  - the feed view model's state machine: idle, loading, loaded, paging,
    page-failed, refreshing, failed
  - pagination and deduplication
  - search debounce and stale-response handling, **without real sleeps**
    (inject a clock)
  - image request coalescing (N concurrent requests produce 1 fetch)
  - the network client against a stubbed `URLProtocol`, covering status
    mapping, 429 with `Retry-After`, and timeouts
- Tests must be **deterministic**:
  - no real network
  - a fixed `Locale`, `TimeZone`, and "now"
  - the same results on any machine, in any time zone
- At least **one UI test** that launches the app against stubbed data (for
  example, through a launch argument) and walks feed → detail → bookmark →
  Saved.
- Every test must be able to fail. A test that passes on both branches of a
  `switch` is not a test.

### CI
- A GitHub Actions workflow that builds and runs unit tests on every push.

---

## Deliverables

1. **The repository**, with a commit history that tells the story. We read
   commits. Small, focused commits with real messages are best.
2. **A README** containing:
   - how to build, run, and test
   - an architecture overview (a diagram is welcome)
   - **key decisions and tradeoffs**: what you chose, what you rejected, and why
   - API contract differences you found (see "First task" above)
   - known limitations, and what you'd do with another week
   - any requirement you deviated from, and why
3. **Screenshots or a short screen recording**, including Dynamic Type at AX5
   and dark mode.

---

## Explicitly out of scope

- Push notifications, accounts and sign-in, and widgets. You may *discuss* how
  you'd add them; that's a panel question.
- Pixel-perfect matching of the mocks.
- 100% code coverage. Test what matters, and explain what you didn't test.
