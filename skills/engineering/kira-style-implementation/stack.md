# Stack Best Practices

> **Targets:** React 19 · TypeScript 5.x · MUI v7 · Java 17+ (LTS 25 recommended) · Spring Boot 4.0 / Spring Framework 7.
> **Last verified:** 2026-05.
>
> This file is **baked for speed and offline use** — do *not* fetch the linked sources on every invocation. Fetch a source only when (a) the project's installed version differs from a target above, or (b) a detail here looks stale. When you do, update the date stamp. Rot is tracked in [skills repo issue #5](https://github.com/yzlaboratory/skills/issues/5).

The principles in [SKILL.md](SKILL.md) and [abstraction.md](abstraction.md) still rule. This file is how they land in each technology.

---

## Frontend

### React 19

**`useEffect` is an escape hatch, not lifecycle glue.** An Effect is only for (1) synchronizing with an *external* system (non-React widget, browser API, subscription) and (2) data fetching with cleanup. Governing line: *code that runs because a component was displayed belongs in an Effect; everything else belongs in an event handler.* Most `useEffect` you see is someone fighting the render model.

| Smell (🔴 in an Effect) | Fix (✅) |
|---|---|
| Transforming data for render | Compute during render |
| Caching an expensive calculation | `useMemo` |
| Logic that ran from a user action | Event handler |
| Resetting all state on prop change | `key` prop |
| Adjusting some state on prop change | Derive during render (or set state during render) |
| Chains of Effects setting state | Compute it all in one event handler |
| Notifying a parent of a state change | Lift state up / do it in the same handler |
| Subscribing to an external store | `useSyncExternalStore` |

- **Actions over manual async state.** For form/async work use `useActionState` (state + dispatch + `isPending` in one), `useFormStatus` for nested submit UI, and `useOptimistic` for optimistic updates with automatic rollback. The `use()` hook reads a promise or context and may be called conditionally.
- **Let the React Compiler memoize.** Where the compiler is enabled, stop hand-writing `useMemo` / `useCallback` / `React.memo`; add them back only against a measured problem.
- Sources: [You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect) · [Escape Hatches](https://react.dev/learn/escape-hatches) · [React 19 release](https://react.dev/blog/2024/12/05/react-19) · [React Compiler](https://react.dev/learn/react-compiler).

### Escape hatches

- **No silent suppression.** Never disable a lint rule (`eslint-disable`), silence the type checker (`// @ts-expect-error`, `// @ts-ignore`), reach for `autoFocus`, or cast to `any` without an inline comment stating the explicit, justified reason. An unexplained suppression is a defect — fix the underlying issue, or justify the exception in one line. This is one of the few places a comment is *required* (it carries a *why* the code can't), so make it a real reason, not a restatement of the rule being disabled.

### TypeScript

- **`strict` is non-negotiable** in `tsconfig`.
- **Never `any`; reach for `unknown`** at boundaries and narrow. `any` is a hole bugs hide in.
- **`interface` for object shapes, `type` for unions/intersections/aliases.**
- **Discriminated unions to make impossible states unrepresentable** — a tagged variant per state beats a bag of optional booleans.
- **`satisfies`** to type-check a literal against a type while keeping its narrow inferred type.
- Sources: [Handbook — Everyday Types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html) · [Do's and Don'ts](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html) · [`strict`](https://www.typescriptlang.org/tsconfig/#strict) · [Total TypeScript](https://www.totaltypescript.com/).

### MUI (Material UI v7)

- **`sx` for one-off styles; `styled` for reusable components.** Don't scatter the same `sx` object across many call sites.
- **Theme via `createTheme` + `ThemeProvider`** — never mutate the theme; memoize it so it isn't recreated each render.
- **Highly dynamic values → CSS variables**, not a fresh `sx` object every render.
- **Import individually** so tree-shaking works.
- Sources: [How to customize](https://mui.com/material-ui/customization/how-to-customize/) · [The `sx` prop](https://mui.com/system/getting-started/the-sx-prop/) · [Theming](https://mui.com/material-ui/customization/theming/).

---

## Backend

### Modern Java

- **`record`s are the default data carrier** — DTOs, value objects, anything immutable.
- **Sealed interface + records + pattern-matching `switch`** for a closed set of variants; the compiler enforces exhaustiveness. This is the *earned* OOP from [abstraction.md](abstraction.md) — model a fixed variant set and let the type system check every case.
- **`Optional` for possibly-absent return values only** — never fields or parameters, never `.get()` without a check.
- **Immutability by default** — `final` fields, unmodifiable collections.
- Sources: [dev.java (Oracle)](https://dev.java/) — records, sealed classes, pattern matching. Reference book: *Effective Java*, 3rd ed.

### Spring Boot 4 (REST)

Boot 4.0 on Spring Framework 7 / Jakarta EE 11.

- **Thin controllers.** Controllers handle HTTP only — routing, status codes, (de)serialization. Business logic lives in the service layer; persistence in repositories.
- **DTOs at the boundary, never entities.** Use `record` DTOs with Bean Validation (`@Valid`, `@NotNull`, `@Size`, `@Email`).
- **Errors as `ProblemDetail` (RFC 7807, obsoleted by 9457).** Centralize in a `@RestControllerAdvice` (extend `ResponseEntityExceptionHandler`) or enable `spring.mvc.problemdetails.enabled=true`.
- **Use first-class API versioning** (new in Boot 4) — path / header / query / media-type strategies in MVC and WebFlux. Don't hand-roll it.
- **Declarative HTTP clients** (`@HttpExchange` interfaces) over boilerplate `WebClient`/`RestTemplate`.
- **Constructor injection with `final` fields** — not field injection.
- **Migration gotchas to expect, not teach:** Jackson 3 moved `com.fasterxml.jackson` → `tools.jackson`; Spring Security 7 enforces CSRF harder, so state-changing requests are blocked without an explicit `SecurityFilterChain`.
- Sources: [Spring Boot 4.0 announcement](https://spring.io/blog/2025/11/20/spring-boot-4-0-0-available-now/) · [Release Notes](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Release-Notes) · [Migration Guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Migration-Guide) · [Error handling for REST (Baeldung)](https://www.baeldung.com/exception-handling-for-rest-with-spring) · [API versioning (Baeldung)](https://www.baeldung.com/spring-api-versioning) · [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html).
