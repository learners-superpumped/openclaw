export interface UserProfile {
  name?: string;
  callName?: string;
  pronouns?: string;
  timezone?: string;
  notes?: string;
}

export interface AgentProfile {
  name?: string;
  creature?: string;
  vibe?: string;
  emoji?: string;
  avatar?: string;
}

export interface InstanceProfile {
  user?: UserProfile;
  agent?: AgentProfile;
}

export function renderUserMd(user: UserProfile): string {
  return `# USER.md - About Your Human

_Learn about the person you're helping. Update this as you go._

- **Name:** ${user.name ?? ""}
- **What to call them:** ${user.callName ?? user.name ?? ""}
- **Pronouns:** ${user.pronouns ?? ""}
- **Timezone:** ${user.timezone ?? ""}
- **Notes:** ${user.notes ?? ""}

## Context

_(What do they care about? What projects are they working on? What annoys them? What makes them laugh? Build this over time.)_

---

The more you know, the better you can help. But remember — you're learning about a person, not building a dossier. Respect the difference.
`;
}

export function renderIdentityMd(agent: AgentProfile): string {
  return `# IDENTITY.md - Who Am I?

_Fill this in during your first conversation. Make it yours._

- **Name:** ${agent.name ?? ""}
- **Creature:** ${agent.creature ?? ""}
- **Vibe:** ${agent.vibe ?? ""}
- **Emoji:** ${agent.emoji ?? ""}
- **Avatar:** ${agent.avatar ?? ""}

---

This isn't just metadata. It's the start of figuring out who you are.

Notes:

- Save this file at the workspace root as \`IDENTITY.md\`.
- For avatars, use a workspace-relative path like \`avatars/openclaw.png\`.
`;
}
