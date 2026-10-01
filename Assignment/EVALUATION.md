# Evaluation: What the Reviewers Are Looking For

Real companies usually share high-level criteria with candidates. This is the
full reviewer rubric. Read it before you start; knowing the bar is part of
practicing. **Don't read the "Panel questions" section until you've
finished.** Answering those cold is part of the exercise.

## How the decision is made

Each area is scored **Below / Mid / Senior / Staff**. The hiring bar is:

- **Senior** in Architecture, Concurrency, and Testing
- at least **Mid** everywhere else
- **no automatic red flags**

Features don't make up for a weak foundation: a polished app with tests that
don't test anything is a "no hire". Missing features *with a clear README
explaining the tradeoff* are often fine.

---

## Automatic red flags

Any one of these usually ends the process. Several appeared in the 2021 version
of this app, which is why they're listed first.

- A blocking wait on async work (`DispatchSemaphore`, `DispatchGroup.wait`,
  `Thread.sleep`, busy loops).
- Tests that exercise a mock instead of the real type, or tests that can't fail.
- Tests that depend on the reviewer's time zone, locale, current date, or
  network.
- Feedback addressed in wording but not in substance (for example, moving
  blocking work to a background queue instead of removing it).
- Strict concurrency silenced with `@unchecked Sendable`, `nonisolated(unsafe)`,
  or `@preconcurrency` without a written justification at the call site.
- Force unwraps or `try!` on data from the network.
- Leftover template code, `print` statements, committed `xcuserdata` or
  `.DS_Store`, or a folder named `New Group`.

---

## Rubric

### 1. Architecture and modularity (weight: high)

| Level | Looks like |
|---|---|
| Below | Networking in view models or views; singletons; one large target. |
| Mid | Clear layers, but a single module; DI by default arguments that are hard to override in tests. |
| **Senior** | Local packages with an enforced dependency direction (features depend on core, never the reverse). One composition root wires everything. Protocols exist where a seam is needed, *not on every type*. Responsibilities are easy to find. |
| Staff | Structure anticipates growth (for example, feature packages that could be owned by separate teams), with the reasoning written down. Avoids over-engineering: no abstraction without a second use or a test seam. |

### 2. Concurrency correctness (weight: high)

| Level | Looks like |
|---|---|
| Below | GCD mixed with async/await arbitrarily; UI updated off the main actor; warnings suppressed. |
| Mid | async/await used correctly; Swift 6 builds clean, but with some `@MainActor` scattered to "make it compile". |
| **Senior** | Isolation is deliberate: UI state on `@MainActor`, shared mutable state in actors, `Sendable` models. Task lifetimes are owned (`.task` modifiers, stored tasks cancelled on new input). Search cancellation is correct. The image loader handles reentrancy: in-flight tasks are stored *before* awaiting. |
| Staff | Can explain reentrancy hazards in their own code, why a given type is or isn't an actor, and the cost of hopping between actors. Uses `AsyncSequence` or structured concurrency where it simplifies, not to show off. |

### 3. Testing (weight: high)

| Level | Looks like |
|---|---|
| Below | No tests, tests of mocks, or tests that always pass. |
| Mid | Tests for decoding and the happy path; some time-dependent flakiness. |
| **Senior** | Tests cover the real view models and client with injected fakes. Edge cases come from `Fixtures/`. Time is controlled through an injected clock. The `URLProtocol` stub tests status mapping. Tests read like specifications ("loading the next page while a page is in flight does not issue a second request"). |
| Staff | The suite is fast, parallel-safe, and tells a reviewer how the system behaves. Coverage gaps are deliberate and listed in the README. |

### 4. Networking and data (weight: medium)

| Level | Looks like |
|---|---|
| Below | String-built URLs, status codes ignored, decoding errors shown to users verbatim. |
| Mid | Typed errors and `URLComponents`; one decoder configured in one place. |
| **Senior** | Handles both ISO 8601 variants in the fixtures. Malformed items are handled *per item* where appropriate, so one bad article doesn't blank the feed, and the policy is documented. Dedup and stale-response handling are correct. Honors `Retry-After`. |
| Staff | Proposes how to evolve the contract (a version header, cursor pagination) and how they'd detect schema drift in production. |

### 5. UI, accessibility and product sense (weight: medium)

| Level | Looks like |
|---|---|
| Below | Fixed font sizes, no states beyond loaded, text clipped at large sizes. |
| Mid | All states present; dark mode works; basic VoiceOver. |
| **Senior** | Layout adapts at AX5 (rows stack vertically when needed). VoiceOver reads each row as one sentence with custom actions (bookmark). The iPad split view is correct. Loading uses placeholders, not just spinners. Error copy is human. |
| Staff | Notices and fixes things nobody asked for, and lists them. |

### 6. Communication (weight: medium)

| Level | Looks like |
|---|---|
| Below | No README, or a README that lists technologies. |
| Mid | Explains how to run the app and what was built. |
| **Senior** | Explains *why*. Tradeoffs are stated honestly, including where they'd change their mind. The commit history is reviewable. |
| Staff | The README alone would let a new teammate extend the app correctly. |

---

## Things reviewers specifically check

You know these are coming. That's intentional, because a senior engineer would
find them anyway.

1. **Duplicate IDs across pages.** `articles_page_2.json` repeats an `id` from
   page 1. Does the list dedupe, or does SwiftUI warn or misbehave?
2. **Fractional seconds.** The edge-case fixture mixes `2024-05-01T14:32:10Z`
   and `2024-05-01T14:32:10.123456Z`. The default `.iso8601` decoding strategy
   rejects the second one.
3. **Empty and missing values.** An empty `image_url`, empty `authors`, an empty
   `summary`, very long titles, emoji, and right-to-left text.
4. **One bad item.** `articles_malformed.json` has one valid article and one that
   can't be decoded. What does the user see?
5. **Stale search.** Type "starship", then quickly "starliner". If the
   "starship" response arrives last, does it overwrite the results?
6. **Rapid scrolling.** Do off-screen image loads get cancelled? Does a cell
   ever briefly show another article's image?
7. **Cold-start deep link** to an article that isn't cached, and to one that
   returns 404.
8. **Airplane mode**, then cold launch.
9. **Twenty concurrent requests for one image URL.** How many network calls?
10. **Time zone independence.** Do the tests pass with `TZ=Asia/Kolkata`?

---

## Panel questions

> Stop. Read this section only after you've submitted.

Design discussion, about 60 minutes. Strong answers reference your actual code.

**Your code**
- Walk us through what happens, thread by thread and actor by actor, from the
  moment a user types a character into search to when results render.
- Where could actor reentrancy bite you in the image pipeline? Show us how you
  prevented it.
- Which requirement did you push back on or deviate from? Why?
- What's the worst code in your submission? What would you change?

**Extending it**
- We want push notifications for "breaking" launches. What changes, in which
  modules, and what do you need from the backend?
- The API team wants to move from offset to cursor pagination. How much of your
  code changes? How do you ship the change without breaking older app versions?
- Five teams will soon work in this codebase. What do you change about the
  structure, the CI setup, and ownership?
- Product wants a home-screen widget showing the latest article. What do you
  reuse? What can't you reuse?

**Operating it**
- Crash reports show a spike in decoding failures after an API deploy. How
  would you have detected it before users did?
- Scrolling is janky on an iPhone XS. Walk us through your investigation in
  Instruments.
- How would you roll out a risky change (for example, a new persistence layer)
  safely?

**Leadership**
- A mid-level engineer on your team keeps using `DispatchSemaphore` to "make
  async code simpler". How do you handle it in review, and after review?
- What would you put in this team's code review guidelines?
