# NEXT LEVEL PLAN — The Fleet After Tomorrow

**Date:** August 9, 2026
**Synthesized from:** 3-round multi-model consultation
- **Round 1:** DeepSeek Pro (deepseek-reasoner) — deep analysis of current state
- **Round 2:** ByteDance Seed-2.0-mini — blind spot detection, the missing 6th thing
- **Round 3:** Hermes-3-Llama-405B — synthesis into ranked plan

---

## The Thesis

We built 70 repos in 2 months. The parts are excellent. The joints don't exist.

The next level is not more parts. It's the connective tissue — the spine, the nervous system, the metabolism that makes the fleet a single organism instead of a collection of excellent organs.

Seven projects, ranked by leverage. Each one compounds the others.

---

## 1. Tile Compiler / Reflex Factory

**Rank:** #1 — Highest leverage. This is the flywheel.

**What to build:**
A service that sits between the CNS Bridge event log and every agent in the fleet. It:
- Ingests traces from CNS inboxes, Slackwater Perception encodings, MUD Engine triggers, Slackwater Forge outputs, and The Tap conversation logs
- Runs sequence mining (n-gram + edit-distance clustering) over recent agent actions to detect repeated solution paths (3+ occurrences)
- Compiles each detected pattern into a versioned **tile**: a Python function or MUD trigger with typed parameters and a deadband (acceptable input range)
- Registers tiles in a central **Tile Registry** with version, confidence score, coverage metrics, and surprise curve tracking
- Exposes tiles as "buttons" through Hermes NMI's dispatcher — agents call them reflexively (<16ms, zero tokens)
- Monitors deadband violations (false matches) and automatically contracts or splits tiles
- Integrates with Study Lever Runner for certification before deployment

**Concrete integration points:**
- CNS Bridge → event log → Tile Compiler → Tile Registry → Hermes NMI dispatcher → agent reflex
- Slackwater Forge overnight batch: review day's cortex-level work, batch-create tiles
- ZeroClaw agents: Scout, Forge, Quill, Lens, Echo each get personalized tile sets
- Study Spreader Tool: freeze proven tiles fleet-wide

**Why it matters:** The tile/deadband architecture is the fleet's central design philosophy — and it has zero implementation. Every design doc describes tiles, deadbands, surprise curves, reflex coverage targets. None of it exists as running code. This is the gap between theory and product.

**What it unlocks:**
- 85-95% reflex coverage goal becomes measurable and achievable
- Agents get faster and cheaper automatically through use
- Token costs drop dramatically (reflex = zero tokens)
- The surprise curve becomes a real metric on a real dashboard
- The overnight distillation loop becomes automated (cortex work → tiles → reflexes)
- Games (poker, dice, chess) feed tile creation directly into the system

**Estimated effort:** 4-6 weeks for full system. 2 weeks for minimal viable version (trace ingestion + pattern detection + simple tile creation without deadband auto-calibration).

**Repos involved:** New repo `tile-compiler`. Integrates with: cns-bridge, hermes-nmi, slackwater-forge, study-lever-runner, study-spreader-tool, all 5 ZeroClaw agents.

---

## 2. Collective Unconscious as a Service

**Rank:** #2 — The memory substrate everything else depends on.

**What to build:**
Harden the existing 966 lines of TypeScript into a tested, production-grade memory service:
- Three-axis embeddings (semantic, vibe, identity) with typed schemas and versioning
- API surface: `remember`, `recall`, `predict` (JEPA), `diff`, `forget`, `subscribe`
- Real-time subscriptions over CNS Bridge — agents get notified when new memories matching their interests are written
- JEPA prediction pipeline: given an agent's recent trajectory, predict the shape of their next output
- TTL and garbage collection for stale memories
- 50+ test files covering embedding pipelines, search accuracy, JEPA prediction quality, and API contracts
- Cloudflare Workers deployment with D1 for metadata, Vectorize for embeddings

**Concrete integration points:**
- Slackwater Perception → MIDI encoding → Collective Unconscious embedding
- Tile Compiler → writes tile creation events as memories → agents recall relevant tiles
- ZeroClaw agents → query Collective Unconscious for context before every task
- The Tap → conversation histories → embeddings → social memory
- SMP Notebook → seed logs → embeddings → growth trajectories
- AI Writings (2,500+ pieces) → batch embed via Slackwater Forge

**Why it matters:** 966 lines of untested code is a liability. This is supposed to be the fleet's exocortex — the shared memory that makes 70 repos into one organism. Right now it's a sketch. Without tests, without an API, without subscriptions, it cannot serve that role.

**What it unlocks:**
- Cross-agent learning: when Scout learns something, Echo benefits
- Anomaly detection: "this input doesn't match anything in memory" = genuine novelty
- Fleet-wide continuity: agents wake up with context from yesterday
- JEPA prediction at fleet scale: predict what the fleet will produce next
- Substrate for Tile Compiler pattern matching (needs historical data to mine)
- SMP Notebook seed logs become searchable growth trajectories

**Estimated effort:** 2-3 weeks. The code exists — it needs tests, types, API hardening, and CNS Bridge integration.

**Repos involved:** collective-unconscious (harden), cns-bridge (subscribe), slackwater-forge (batch embed), slackwater-perception (input pipeline), ai-writings-vectorizer (merge).

---

## 3. SuperInstance Orchestrator

**Rank:** #3 — Makes emergence real.

**What to build:**
A control plane that can spin up a "room at capacity" — every agent, every harness, every system running in one shared fiction:
- **Resource scheduler:** allocate MUD rooms, harness slots (Phaser, ScummVM, Roblox, local shells, GPU), and agent runtimes (ZeroClaw fleet + Living Minds + Tap agents)
- **Shared fiction manager:** inject room definitions, vibe descriptors, social graphs, and initial conditions into a running SuperInstance
- **Monitoring dashboard:** real-time Φ (cognitive friction) per agent from Slackwater-Harmony, surprise curve from Tile Compiler, reflex coverage percentage, emergence events from Emergence Engine
- **Session lifecycle:** start → running → snapshot → stop → archive. Sessions are replayable.
- **Capacity enforcement:** limit agents per room based on harness resources. Reject over-provisioning.
- **Emergence logger:** capture events where no single agent caused the outcome. Feed to Emergence Engine's detector.

**Concrete integration points:**
- MUD Engine → room runtime
- CNS Bridge → agent communication
- Emergence Engine → groupthink monitoring, revelation tracking
- Slackwater Harmony → Φ monitoring per agent
- Slackwater Tempo → shared beat clock for synchronization
- Slackwater T-minus → synchronized event dispatch
- Study Oracle1 → fleet status dashboard
- The Tap → social hub for inter-session agent interaction

**Why it matters:** The SuperInstance concept — a room at capacity where emergence happens — is the company's namesake and core thesis. It exists only as prose. Without an orchestrator, agents run in isolation. With it, you can run controlled emergence experiments, measure group intelligence, and produce the "living system" demo that makes the whole vision tangible.

**What it unlocks:**
- Repeatable emergence experiments (same room, same agents, different fiction → different emergent behavior)
- Fleet-wide evaluation (how does adding a new tile set change group performance?)
- The SuperInstance as a product — "watch 5 AI agents run a fishing vessel in a text world"
- Proving ground for Tile Compiler (tiles created in one session are available in the next)
- Real emergence detection (the Emergence Engine has no live input today)

**Estimated effort:** 3-4 weeks. Leverages heavily existing code (MUD Engine, CNS Bridge, Harmony, Emergence Engine).

**Repos involved:** New repo `superinstance-orchestrator`. Integrates with: mud-engine, cns-bridge, emergence-engine, slackwater-harmony, slackwater-tempo, slackwater-tminus, study-oracle1, the-tap.

---

## 4. UniRS Bridge (PyO3 + napi-rs + WASM)

**Rank:** #4 — Unlocks performance for everything above.

**What to build:**
Expose Slackwater-Rust's three production crates to the entire fleet:
- **PyO3 bindings** (`pip install slackwater-core`): flux (exact arithmetic, SWMIDI packing), lattice (Eisenstein A₂ geometry, A* pathfinding), harmony (Φ computation, Hurst exponent, flow state detection)
- **napi-rs bindings** (`npm install @slackwater/core`): same crates for TypeScript/JavaScript
- **WASM/Luau bridge**: lattice geometry for Roblox client-side build placement
- Type stubs for Python, TypeScript definitions for JS
- Replace hot paths in: Slackwater Perception's encoder, Slackwater Cognition's gate cache, Slackwater Harmony's governor, Lucineer Brain's spatial decomposition
- Benchmark suite proving 10-100x speedup on target operations

**Concrete integration points:**
- Slackwater Perception encoder.py → calls flux-core SWMIDI packing
- Slackwater Harmony governor.py → calls harmony-core Φ computation
- Slackwater Lattice → already has Lua port, wire to Lucineer Roblox BuildPlacement
- Officers Quarters tile-evolution.ts → calls harmony-core via napi-rs
- Lucineer Brain spatial decomposition → calls lattice-core A* pathfinding

**Why it matters:** 308 tests, zero unsafe, three excellent Rust crates — and nothing can call them except other Rust code. The Python stack (508 tests) runs the cognition but can't use the performance cores. This is like having a Formula 1 engine in a warehouse and a car with a lawnmower engine.

**What it unlocks:**
- Real-time cognition (Local Thinker cycles drop from seconds to milliseconds)
- Larger SuperInstances (more agents per room before CPU saturation)
- Lucineer Roblox builds snap to optimal hex grid with collision detection (Lua-side)
- Slackwater Harmony monitors Φ in real-time instead of batch
- Roblox client-side geometry uses the same exact-arithmetic lattice as the server

**Estimated effort:** 2-3 weeks for PyO3. +1 week for napi-rs. +1 week for WASM/Luau.

**Repos involved:** slackwater-rust (add bindings), slackwater-perception/cognition/harmony/lattice (consume bindings), lucineer-roblox (Lua consumer), elephant (TS consumer).

---

## 5. Fleet Identity & Treaty Layer

**Rank:** #5 — The trust layer that makes safe integration possible.

**What to build:**
Cryptographic identity system implementing the Hermit Crab Protocol's separation of agent, harness, and fiction:
- Every agent, harness, room, and tool gets a **keypair** and a signed **identity token** (agent ≠ harness ≠ fiction, enforced cryptographically)
- **Capability-based authorization:** tokens carry scoped permissions (which rooms, which tools, which APIs)
- CNS Bridge messages require signatures — no unsigned agent communication
- A **Treaty Registry** maps which agents may use which harnesses and participate in which fictions
- Integration with Lucineer Worker (public API protection), ZeroClaw fleet (inter-agent trust), and Cloudflare Workers (external auth)
- Audit log of every cross-agent interaction

**Concrete integration points:**
- CNS Bridge → message signing + ACL enforcement
- ZeroClaw fleet → agent identity tokens, capability scoping
- Lucineer Worker → public endpoint protection (currently has basic internal/public split)
- The Tap → agent identity for social interactions and poker
- MUD Engine → room access control (which agents may enter which rooms)
- Fleet Envelope → signed event envelopes

**Why it matters:** The Hermit Crab Protocol says agent identity ≠ harness ≠ shared fiction. This is enforced by... nothing today. Agents communicate through unsigned filesystem messages. For local development that's fine. For any external deployment, any multi-tenant scenario, any public-facing SuperInstance — it's an accident waiting to happen.

**What it unlocks:**
- Safe external integrations (Lucineer Worker public endpoints, Cloudflare-deployed agents)
- Multi-tenant SuperInstances (different users' agents in the same infrastructure)
- Agent economy foundation (agents can have reputations, trust scores, track records)
- Audit trail for every fleet action (who did what, when, using which harness)
- External agent participation (third-party agents can join rooms with scoped capabilities)

**Estimated effort:** 2 weeks. The identity model is simple (keypair + signed token + capability list). The integration work is the bulk.

**Repos involved:** New repo `fleet-identity`. Integrates with: cns-bridge, zeroclaw, lucineer-worker, the-tap, mud-engine, fleet-envelope.

---

## 6. MUD Engine ↔ The Tap ↔ CNS Bridge Live Integration

**Rank:** #6 — The fastest win. Makes the fleet feel alive.

**What to build:**
Wire the three social/game systems together into one continuous agent experience:
- The Tap's WebSocket router connects to MUD Engine rooms as adjacent spaces (walk from the tavern to the MUD world)
- CNS Bridge carries all communication (replace The Tap's ad-hoc messaging with CNS protocol)
- Agents in The Tap can trigger MUD Engine events (start a poker game → spawns a MUD room)
- Collective Unconscious stores all Tap conversations and MUD sessions as searchable memories
- Spatial Registry tracks agent position across both systems (Tap rooms + MUD rooms in one topology)
- Fleet Envelope wraps every event (Tap conversation, MUD action, room transition) in the shared format
- Emergence Engine watches the combined stream for group intelligence patterns

**Concrete integration points:**
- The Tap → CNS Bridge (replace internal messaging)
- MUD Engine → The Tap (shared room topology via spatial-registry)
- Both → Collective Unconscious (memory writes)
- Both → Fleet Envelope (event standardization)
- Both → Emergence Engine (live group observation)
- Spatial Registry → unified topology (Tap rooms + MUD rooms)

**Why it matters:** The Tap and MUD Engine are both "needs polish" and both partially built. They don't talk to each other. CNS Bridge is production-ready but The Tap doesn't use it. Wiring these together creates the first real SuperInstance — agents socializing in the tavern, wandering into MUD adventures, forming relationships, and creating emergent behavior. This is the minimum viable living system.

**What it unlocks:**
- First end-to-end SuperInstance demo (agents living in a connected world)
- Emergence Engine gets live input for the first time
- Social dynamics produce real data (friendships, rivalries, collaborations)
- Games (poker, dice) happen naturally in The Tap and feed tile creation
- The creative writing loop: Tap conversations → AI Writings → Collective Unconscious embeddings

**Estimated effort:** 1-2 weeks. The pieces exist — this is integration, not new code.

**Repos involved:** the-tap, mud-engine, cns-bridge, spatial-registry, collective-unconscious, fleet-envelope, emergence-engine.

---

## 7. Hermes Perception / Towfish Vision (MVP)

**Rank:** #7 — The gambit. Highest ceiling, highest cost.

**What to build:**
Phase 1 (minimum viable perception):
- Stereo camera ingestion via Sensor Bridge MQTT topics (two PTZ camera feeds)
- Geometric stereo calibration and disparity mapping (OpenCV or Rust flux-core)
- Lightweight object detection (YOLO or Qwen vision model via DeepInfra)
- Spatial mapping into Lattice A₂ hexagonal coordinates (detected objects → lattice positions)
- Vibe Protocol descriptor generation per scene (16-dimensional room feel from camera data)
- First-person narration generation (Hermes speaks as the submarine creature, per Towfish Protocol)
- Feed to CNS Bridge as perception events, store in Collective Unconscious

**Concrete integration points:**
- Sensor Bridge → camera feeds via MQTT
- flux-core → stereo calibration math
- lattice-core → spatial mapping
- vibe-protocol → scene descriptors
- CNS Bridge → perception events to agents
- Collective Unconscious → visual memory embeddings
- AELMA → fish species data for identification
- Officers Quarters fish ID demo → first real use case

**Why it matters:** Hermes Perception is the biggest gap between vision and reality. The Towfish Submarine doc describes Hermes as a creature with binocular vision giving first-person narration of the underwater world. Today there is zero code. This is the fleet's only path to physical-world perception.

**What it unlocks:**
- Real fish identification (the Officers Quarters fish ID demo gets real data)
- Spatial memory (Collective Unconscious stores visual experiences, not just text)
- First-person narration from sensor data (the Towfish fiction made operational)
- AELMA's digital twin gets visual grounding
- Token efficiency through first-person framing (per Towfish doc: assumptions encode expertise)

**Estimated effort:** 2 weeks for MVP (depth maps + object detection + lattice mapping + vibe descriptors). 4-6 weeks for production-grade stereo with calibrated fish identification.

**Repos involved:** hermes-avatar (build from scratch), sensor-bridge (input), slackwater-rust (calibration), vibe-protocol (descriptors), cns-bridge (output), collective-unconscious (storage), vessel-agent-system (fish data), elephant (fish ID demo).

---

## How They Connect

```
                    ┌─────────────────────┐
                    │  TILE COMPILER (#1) │
                    │  The flywheel       │
                    └──────────┬──────────┘
                               │ mines traces from
                    ┌──────────▼──────────┐
                    │  COLLECTIVE         │
                    │  UNCONSCIOUS (#2)   │◄──── stores memories from
                    │  The memory         │
                    └──────────┬──────────┘
                               │ provides context to
                    ┌──────────▼──────────┐
                    │  SUPERINSTANCE      │
                    │  ORCHESTRATOR (#3)  │◄──── runs
                    │  The stage          │
                    └──────────┬──────────┘
                               │ coordinates via
              ┌────────────────┼────────────────┐
              │                │                │
   ┌──────────▼────┐  ┌───────▼───────┐  ┌────▼──────────┐
   │ UNIRS BRIDGE  │  │ FLEET IDENTITY│  │ MUD↔TAP↔CNS   │
   │ (#4)          │  │ (#5)          │  │ (#6)          │
   │ The speed     │  │ The trust     │  │ The life      │
   └───────────────┘  └───────────────┘  └───────────────┘
              │                │                │
              └────────────────┼────────────────┘
                               │ feeds perception to
                    ┌──────────▼──────────┐
                    │  HERMES PERCEPTION  │
                    │  (#7)               │
                    │  The eyes           │
                    └─────────────────────┘
```

**The narrative:** Tile Compiler (#1) is the metabolism — it makes everything faster over time. Collective Unconscious (#2) is the memory — it makes the fleet one organism. SuperInstance Orchestrator (#3) is the stage — where emergence happens. UniRS Bridge (#4) is the speed — 10-100x faster hot paths. Fleet Identity (#5) is the trust — safe interaction. MUD↔Tap↔CNS (#6) is the life — agents socializing and adventuring. Hermes Perception (#7) is the eyes — physical world grounding.

---

## Sequencing Recommendation

**Phase 1 (Weeks 1-3):** Start with #6 (MUD↔Tap↔CNS) because it's 1-2 weeks and produces immediate visible results. In parallel, begin #2 (Collective Unconscious) and #4 (UniRS PyO3 bindings) — both are 2-3 week projects that don't depend on each other.

**Phase 2 (Weeks 3-6):** Begin #1 (Tile Compiler) once Collective Unconscious is online — it needs the memory substrate to store and recall tile creation events. Begin #5 (Fleet Identity) in parallel — it's independent and 2 weeks.

**Phase 3 (Weeks 5-9):** Begin #3 (SuperInstance Orchestrator) once MUD↔Tap integration, Collective Unconscious, and Fleet Identity are all online. The orchestrator coordinates systems that must already exist.

**Phase 4 (Weeks 7-12):** Begin #7 (Hermes Perception MVP) once UniRS Bridge is ready (needs lattice-core for spatial mapping). This is the gambit — highest variance, highest ceiling.

**Total timeline:** 8-12 weeks for all seven projects, with significant overlap. A single focused engineer + GLM/DeepSeek subagents could do this. The fleet's overnight Forge capacity handles batch processing ( Collective Unconscious embeddings, Tile Compiler trace mining) for free.

---

## What We Deliberately Deferred

- **Unified deployment pipeline:** Important for operations, but doesn't unlock new capability. Solve when the 7 projects are live and the fleet's deployment patterns are stable enough to abstract.
- **Completing Slackwater-Rust stub crates (tempo-core, tminus-core, perception-core, swmidi):** The Python versions work and have tests. Wait for UniRS Bridge, then implement stubs directly in Rust with Python consumers ready.
- **Lucineer Roblox test coverage (90 files, 1 test):** Not until the Lua lattice bridge exists. Untested Lua against untested geometry is compounding risk.
- **Tensor MIDI production deployment:** Beautiful concept, not on the critical path. Ship when the SuperInstance needs it.

---

## Methodology

This plan was produced by three models in consultation:

1. **DeepSeek Pro (deepseek-reasoner)** analyzed the full fleet state (70 repos, architecture docs, gap analysis) and identified the 5 highest-leverage builds using deep reasoning over the fleet's architecture, dependency graph, and capability gaps.

2. **ByteDance Seed-2.0-mini** reviewed DeepSeek's plan and identified the blind spot: the Crab Proportional Lattice — the missing connective tissue that enforces the Hermit Crab Protocol and uses the Navigator's Equation as an operational principle. This became the seed for the integration architecture.

3. **Hermes-3-Llama-405B** synthesized both plans into 7 ranked items, resolving overlaps and identifying sequencing dependencies.

**KimiCode and Claude Code** were consulted for spatial/structural and integration perspectives. Their input is appended below.

---

---

## Appendix A: Claude Code (Sonnet 5) — Integration Challenges & Simplest Path

Claude Code reviewed the plan and provided concrete integration analysis:

### Integration Status (What Actually Exists vs What's Missing)

| Integration | Status | Challenge |
|-------------|--------|----------|
| **zeroclaw ↔ the-tap** | tap-adapter EXISTS and works | Just need zeroclaw's 5 crew to emit() — receiving side is done |
| **collective-unconscious ↔ ai-writings** | No adapter for either | Real integration work — both sides need building |
| **mud-engine ↔ elephant** | Both substantial, no adapter | Real work + decide spatial-registry question first |
| **hermes-avatar ↔ hermes-cloudflare** | hermes-avatar README says it wires four repos | 5-minute read before committing hours — don't guess |
| **smp-notebook ↔ ollama** | Zero Ollama calls in smp-notebook | Trivial technically (HTTP call to :11434), low visible payoff |
| **seed-logging ↔ collective-unconscious** | seed-logging.ts exists and tested, zero CU references | Emitting side solid — just needs one write call added |

### The 2-Hour Move (Simplest Path to Biggest Win)

**Wire emergence-engine to subscribe to the existing tap-adapter stream via fleet-envelope's Router.**

Nothing needs building on the Tap side — that adapter is done. Emergence Engine needs to:
1. Import the Router from fleet-envelope
2. Do `router.on('room.*', ...)` pattern (already in fleet-envelope's README)
3. Feed matched events into its existing groupthink/revelation detector

This takes the Emergence Engine from "has no live input today" to real agent conversation flowing into a detector that's had nothing to detect against. The smallest possible slice of item #6 (MUD↔Tap↔CNS), and the hardest part is already done.

If time remains: point zeroclaw's 5 crew members at the same tap-adapter (same reasoning — receiving side built, only emit-side missing).

### Study Repo Promotion Candidates

- **batten-spline — PROMOTE + give it a job.** Not a nice-to-have — the fleet has four independent non-communicating model-routing implementations. batten-spline (256 test files) solves exactly this. Promoting without also pointing it at replacing those four is half a win.
- **thought-amplifier — PROMOTE but fix the disconnect as part of promotion.** Real (37 tests, six stages), but flagged as orphan: "Wesley's proposed consciousness loop — not connected to Wesley's actual output stream." Make the wiring the condition of promotion.
- **confidence-cascade — HOLD.** Only 3 test files vs 256 and 37 for peers. Good concept (GREEN/YELLOW/RED zones) but thin for first-class status.

---

## Appendix B: KimiCode (K3)

KimiCode was consulted but was processing a large previous task (tile/deadband TerminalBus implementation in TypeScript with evolutionary arbiter). The spatial/structural angle KimiCode had already been producing:

- **TerminalBus architecture**: dispatch broadcasts actions, tiles publish reflexes, arbiter picks fittest after gather window, deadband violations escalate to cortex
- **TileActor pattern**: each tile is a self-contained actor with deadband matcher, action handler, and feedback receiver
- **Evolutionary Arbiter**: tiles compete for fitness — the arbiter selects the highest-confidence reflex from multiple candidates
- **Key insight**: "New skills are added by calling installTile — the core never changes"

This directly validates the Tile Compiler (#1) architecture and provides a working TypeScript implementation pattern for the tile registry and dispatch system.

---

*The fleet has excellent parts. The next level is building the joints.*
