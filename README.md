# Monthly Budget

A single-file web app for a month-at-a-time budget. Shows recurring revenue and
expenses by date (1st → last day) with a running **planned** vs **actual** bank balance.

- **Recurrence:** monthly, bi-weekly, weekly, or one-time items
- **Shared live data:** budgets are stored in Supabase and identified by an
  unguessable id in the URL hash (`#b=...`). Anyone with the link sees and edits
  the same budget; changes sync every few seconds.
- **Offline-friendly:** falls back to local browser storage if the network is down.

## Hosting
Static site — served by GitHub Pages from `index.html`. No server required.

## Data
Lives in the `budgets` table of a Supabase project (browser client + publishable
anon key). The anon key is public by design; budget data is protected by the
secret link id, not by the key.
