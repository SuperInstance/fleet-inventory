# FLEET ASSESSMENT — SuperInstance Deep Inventory

**Date:** August 9, 2026
**Scanned:** 150+ repositories under `/home/eileen/projects/`
**Purpose:** What have we built that actually works and can be used right now?

---

## 1. Executive Summary

Casey, here's the honest picture. Over the last two months, the fleet has produced roughly 150 repositories. Of those, about 40 contain real, working, tested code. Another 30 are functional scaffolding — they compile, they have structure, but they're thin. The rest are research papers, study experiments, design docs, content libraries, and one-off explorations. That's not a failure — the papers and experiments feed the production code — but you should know which shelf to reach for at 5 AM.

**What's genuinely production-ready:**

The Slackwater Python stack — six pip-installable packages (perception, cognition, harmony, lattice, tempo, t-minus) with a combined **508+ passing tests**. These are the most tested, most polished code in the entire fleet. They're the cognitive backbone for game agent behavior: perceiving the world as MIDI, measuring cognitive friction (Φ), placing things on a hexagonal lattice, tracking musical time, and replacing polling with predict-and-confirm countdowns.

The Slackwater-Rust workspace — three implemented crates (flux-core, lattice-core, harmony-core) with **308 tests** and zero `unsafe`. These are the performance-critical cores for the same concepts the Python stack handles.

The MUD Engine — a TypeScript monorepo with **10 packages** (core, triggers, agent-runtime, channels, event-bus, dm-rotation, strategy-guild, hermit-crab, immortal-interface, envelope) and integration tests. This is the game engine that runs text-based worlds for AI agents. It has trigger-based perception, telemetry, strategy evolution, and a rotating Dungeon Master.

The Vessel Agent System (AELMA) — **178 Python files, 34 test files** covering catch logging, SignalK integration, bathymetry, tide prediction, fatigue monitoring, crew scheduling, quota management, anomaly detection, MOB detection, predictive maintenance, JEPA modeling, route optimization, and a digital twin. This is the marine stack for the F/V EILEEN, and it is the deepest single repository in the fleet.

**What's close but needs polish:**

Officers' Quarters (12-room Phaser game with intelligent terminals, tile evolution, fish ID demo), Plato's Shell (IDE-as-game-world with dual projection), The Tap (agentic tavern on Cloudflare Workers with poker games), ScummVM Arcade (point-and-click adventure collection), Collective Unconscious (vectorized fleet memory with JEPA prediction), and the Lucineer Roblox pipeline (16 Luau modules, 4-stage AI brain, Cloudflare Worker relay).

**The highest-leverage integration right now:**

Connect Slackwater-Perception → Collective Unconscious → MUD Engine. Perception encodes experience as MIDI tracks. Collective Unconscious embeds creative output into vector space with JEPA trajectory prediction. The MUD Engine runs the world where agents use both. That triangle is the product.

---

## 2. Marine Stack — Everything for the F/V EILEEN and Hermes

### vessel-agent-system (AELMA)
**Status:** 🟢 production-ready · **Last touched:** 2026-08-09 · **178 source files, 34 test files**

This is the marine stack. Nothing else in the fleet comes close in domain coverage. AELMA (the vessel agent) handles:

- **Catch logging** — structured fish harvest records
- **SignalK integration** — the NMEA 2000 / marine data standard
- **Bathymetry** — seafloor depth data (bathymetry.json included)
- **Tide prediction** — timing fishing around tidal currents
- **Fatigue monitoring** — crew rest tracking, critical for safety
- **Crew scheduling** — watch rotations
- **Quota management** — tracking catch against limits
- **Anomaly detection** — spotting equipment failures, unusual patterns
- **MOB (man overboard) detection** — safety-critical
- **Predictive maintenance** — catching failures before they happen
- **JEPA model** — joint embedding predictive architecture for anticipating conditions
- **Route optimization** — fuel-efficient, fish-efficient routing
- **Digital twin** — a full simulation of the vessel
- **H3 spatial indexing** — hexagonal hierarchical spatial indexing
- **LLM narrator** — turning sensor data into natural language
- **Circuit breaker** — failure isolation
- **Fleet manager** — multi-vessel coordination

**Integration target:** This IS the marine stack. It feeds into Hermes Perception (once that repo has code), uses Sensor Bridge for hardware data, and should be the data source for Collective Unconscious embeddings. The digital twin module should connect to the vessel-room-navigator for the visual interface.

### sensor-bridge
**Status:** 🟢 production-ready · **Last touched:** 2026-08-07 · **16 source files, 14 test files**

Connects ESP32 hardware sensors to the exocortex via MQTT. Normalizes raw sensor data, detects patterns, escalates anomalies through a two-agent protocol (Ensign on the ESP32, LaForge in the repo). The architecture is clean: normalize → detect patterns → escalate → store. This is the sensory nervous system.

**Key files:** `bridge.py`, `pattern_detector.py`, `escalation.py`, `normalizer.py`, `mqtt_client.py`
**Integration target:** Feeds AELMA's anomaly detection and the CNS bridge for fleet-wide signal routing.

### vessel-room-navigator
**Status:** 🟡 needs polish · **Last touched:** 2026-08-08 · 2 JS files, 2 test files

ScummVM-meets-Google-Street-View for the boat. Walk between physical rooms (wheelhouse, engine room, galley), check gauges, respond to alarms. 140 tests on rooms-config structure. Deployed at fleet.cocapn.ai. It's a web frontend that needs AELMA data plumbed in to show live readings.

**Integration target:** Visual layer for AELMA's digital twin. Camera feeds from the physical vessel map to rooms here.

### engine-ensign
**Status:** 🟡 needs polish · **Last touched:** 2026-08-07 · 7 source files

ESP32 firmware concepts — the "holo-emitter" metaphor. The Ensign is the runtime agent on the microcontroller. Pairs with sensor-bridge.

### plato-vessel-core
**Status:** 🟡 needs polish · **Last touched:** 2026-08-08 · 6 source files, 4 test files

Vessel protocol definitions for the Plato network stack. Defines how vessels communicate in the fleet.

### hermes-perception
**Status:** 🔴 empty · **Last touched:** no commits

Despite the name and the vision in si-main's README (stereo camera triangulation, first-person framing, halibut identification), this repo has no code. The vision lives in the README of si-main and in AELMA's twin module. This is a placeholder.

### hermes-nmi
**Status:** 🟢 production-ready · **Last touched:** 2026-08-07 · **146 tests in Rust**

Neuro-Muscular Interface — Rust bridge between reasoning (CNS) and action (Claw agents). Translates ReasoningPulses into CommandChains, returns TelemetryFrames. Has a PincherHook for sub-50ms reflex responses that bypass the LLM entirely. The test coverage is excellent (146 tests across pulse, dispatcher, claw_adapter, pincher_hook, telemetry, tension modules).

**Key files:** `src/dispatcher.rs`, `src/pulse.rs`, `src/pincher_hook.rs`, `src/tension.rs`
**Integration target:** The action layer between Hermes's reasoning and the Roblox build execution. Should connect to lucineer-worker's job queue.

---

## 3. Perception Stack — Seeing the Water Column

### slackwater-perception
**Status:** 🟢 production-ready · **104 tests** · **Last touched:** 2026-08-08

The crown jewel of the cognitive Python stack. Encodes any experience — audio, text, game state — as a nine-track MIDI score. Each perceptual dimension gets its own track: pitch, tempo, velocity, timbre, inflection, silence, gesture, intention, attention. The result is not a recording but a *score* that captures resonance between dimensions.

**Key files:** `encoder.py`, `attention.py`, `intention.py`, `convergence.py`, `pitch_tracker.py`, `velocity_mapper.py`
**Integration target:** This is how agents perceive the MUD Engine's world state and the AELMA's sensor data. Feed game state and vessel telemetry in, get MIDI tracks out. Those tracks get embedded in Collective Unconscious.

### slackwater-cognition
**Status:** 🟢 production-ready · **79+ tests** (growing) · **Last touched:** 2026-08-09

Dynamic cognition architecture with a fast "Local Thinker" (plays and journals thoughts every 5 seconds) and a slower "Conductor" (watches the thought stream, adjusts prompts and parameters every 30 seconds). This is novel ML — the training signal is the stream of consciousness itself, the loss function is play quality, and the gradient is prompt adjustment.

**Key modules:** `local_thinker/` (thinker, journal, action_policy), `conductor/` (prompt_updater, quality_scorer), `cascade/` (trust_tracker, gate_cache, gate_intent, gate_llm), `evolution/` (policy_breeder), `temporal/` (temporal reasoning)
**Integration target:** This is the brain for MUD Engine agents. The Local Thinker plays the MUD; the Conductor watches and improves. The cascade system (trust tracking, intent gating) is the decision router.

### slackwater-harmony
**Status:** 🟢 production-ready · **102 tests** · **Last touched:** 2026-08-07

Cognitive friction monitoring using Φ (phi). Triadic architecture: a Harmony Governor tracks friction per agent, an Executive improvises when friction exceeds deadband, a Groove Detector spots system-wide harmony. The Flow State layer detects and protects deep player alignment.

**Key files:** `governor.py`, `executive.py`, `groove_detector.py`, `flow_state.py`, `sandbox.py`
**Integration target:** Monitors agent wellbeing in the MUD Engine and Officers' Quarters. When Φ spikes, the Executive improvises. Flow State protects the good times.

### log-tensor
**Status:** 🟡 needs polish · **Last touched:** 2026-08-08 · 4 test files

Geometric tensor transformers reconceived as guidance systems. Uses proportional navigation (missile guidance theory) for attention mechanisms. The Homing Geometric Transformer extends standard attention with a proportional navigation term: `Attention = softmax(⟨Q,K⟩ + ω·(Q∧K) + N·Vc·λ̇)`. Deep research code — mathematically sound, not production-deployed.

**Key files:** `transforms/ugt.py`, `transforms/hgt_research.py`, `transforms/permutation.py`
**Integration target:** Advanced attention mechanism for Collective Unconscious's JEPA predictions and for AELMA's fish identification model.

### collective-unconscious
**Status:** 🟡 needs polish · **Last touched:** 2026-08-08 · **966 lines of TypeScript**, no tests yet

Vectorized fleet memory on Cloudflare. Three-vector system: semantic (what feels like this?), vibe (what has this feeling?), identity (who/when/what?). JEPA reader predicts the shape of an agent's next piece based on recent trajectory. Endpoints: embed, search, shape, jepa/:id, temporal stamping.

**Key files:** `src/embed.ts` (172 lines), `src/jepa.ts` (254 lines), `src/index.ts` (426 lines), `src/temporal.ts` (114 lines)
**Integration target:** The memory layer for the entire fleet. Slackwater-Perception encodes experience → Collective Unconscious embeds it → MUD Engine agents search it for context → JEPA predicts what comes next. Needs tests badly.

### image-distillation-loop
**Status:** 🟡 needs polish · **Last touched:** 2026-08-07 · 18 source files

Wesley (2B local model) learns to generate images through iterative feedback from teacher models. Visual iteration loop: Wesley describes → image renders → vision model examines → Wesley compares and adjusts.

**Integration target:** Asset generation for Lucineer and the creative stack. Could feed Slackwater Art Spectrum.

### exocortex-core
**Status:** 🟡 needs polish · **Last touched:** 2026-08-07 · 17 source files, 9 test files

External brain prototype. Modules: reflex_cache (.nail reflex cache with exact-hash and vector-nearest-neighbor lookup), voice_gate (STT pattern matching, cascade routing). The model stays frozen; the brain around it grows.

**Integration target:** Voice Reflex Gate's hash-based routing pairs with this. Could serve as the reflex layer for Wesley and the local fleet models.

---

## 4. Game/MUD Stack — Plato's Shell and the Arcade

### mud-engine
**Status:** 🟢 production-ready · **10 packages, integration tests** · **Last touched:** 2026-08-09

A modular text-based game engine for AI agents. Packages: core (world state), triggers (perception system), agent-runtime (agent lifecycle), channels (communication), event-bus (pub/sub), dm-rotation (rotating Dungeon Master AI), strategy-guild (emergent strategy evolution), hermit-crab (workspace + swarm), immortal-interface (waveform dashboard, DM dashboard, spectator grid), envelope (fleet event format).

**Key files:** `packages/core/src/`, `packages/triggers/src/`, `packages/agent-runtime/src/`, `packages/dm-rotation/src/`, `packages/strategy-guild/src/`
**Integration target:** This is the game engine. Slackwater-Cognition's Local Thinker is the agent runtime. Slackwater-Harmony monitors game friction. Slackwater-Perception encodes what agents perceive. Collective Unconscious provides long-term memory. Room-render provides the rendering abstraction.

### officers-quarters
**Status:** 🟡 needs polish · **27 TS files, 3 test files** · **Last touched:** 2026-08-09

12-room Phaser game with Intelligent Terminals and tile evolution. Rooms: Bridge (command center), Flash Station (speed/reflex), Pro Station (deep reasoning), Wesley Station (creative), Scribe Station (memory/records), Hermes Station (communication/routing), and more. Systems: tile-evolution, tile-actors, tile-actor-bus, intelligent-terminal, navigator-terminal, ripple-crdt. Includes a full fish identification demo with species data, sighting generation, and an ID agent.

**Key files:** `src/systems/intelligent-terminal.ts`, `src/systems/tile-evolution.ts`, `src/systems/ripple-crdt.ts`, `src/demos/fish-id/`
**Integration target:** Fish ID demo should connect to AELMA's fish tracking. Tile evolution connects to Slackwater-Harmony's deadband detection. The 12-room topology registers in spatial-registry.

### platos-shell
**Status:** 🟡 needs polish · **34 TS files, 1 test file** · **Last touched:** 2026-08-09

Web-based game where the IDE and the game world are the same surface. Dual projection: Phaser canvas (rendered room) + MUD terminal (text). Includes dialogue system, verb engine, inventory, mini-games, jukebox UI. Has a projection bridge that syncs the two surfaces with perception deadband logic.

**Key files:** `src/projection/ProjectionBridge.ts`, `src/projection/MudFormatter.ts`, `src/dialogue/DialogueSystem.ts`, `src/scenes/RoomScene.ts`, `src/ui/MudTerminal.ts`
**Integration target:** Connects to MUD Engine (terminal) and ScummVM GUI (visual). Projection bridge could use Slackwater-Perception's convergence detection.

### scummvm-arcade
**Status:** 🟡 needs polish · **18 TS files, 5 test files** · **Last touched:** 2026-08-09 · **Live at scummvm-arcade.pages.dev**

Classic point-and-click adventure games in the browser, each with a MUD text-mode twin. Deployed on Cloudflare Pages. Uses WebAssembly-compiled ScummVM engine.

**Integration target:** Each game's MUD twin connects to MUD Engine. The ScummVM GUI design system feeds into Plato's Shell's visual layer.

### scummvm-gui-design
**Status:** 🟡 needs polish · **8 TS files, 3 Python files** · **Last touched:** 2026-08-08

A SCUMM-like point-and-click interface — nine verbs (Look, Use, Talk, Walk, Push, Pull, Open, Close, Give). TypeScript implementation of the classic adventure-game UI for agent worlds.

**Integration target:** The visual interaction layer for MUD Engine worlds. Should plug into Plato's Shell's projection system.

### scummvm-prototype
**Status:** 🟡 needs polish · **17 JS files, 4 test files** · **Last touched:** 2026-08-08**

A from-scratch SCUMM engine in a single HTML file. Vanilla JS, no frameworks. Walk around rooms, pick up objects, talk to NPCs, solve puzzles. Has a poker engine with 18 tests. Dark-tavern-meets-fishing-vessel aesthetic.

**Integration target:** Reference implementation for ScummVM Arcade. The poker engine feeds into The Tap's poker room.

### mud-arena
**Status:** 🟡 needs polish · **25 Python files, 22 test files** · **Last touched:** 2026-08-08

Agent simulation arena using MUD mechanics. Graph-structured rooms, inventories, adventure-game commands. Built-in genetic algorithm for breeding agent strategies. Evolution-ready gym environment for AI agents.

**Integration target:** Testbed for MUD Engine agent strategies. Evolved strategies from the arena feed into the Strategy Guild.

### terrain
**Status:** 🟡 needs polish · **6 Python files, 1 Rust file, 3 test files** · **Last touched:** 2026-08-08**

Converts text MUD descriptions into Three.js scenes at 38 words/sec. 5-room fishing trawler demo (412 polygons, 17 texture maps from 18 lines of MUD markup). Includes a brass porthole shader.

**Integration target:** 3D rendering layer for MUD Engine rooms. Feed room descriptions in, get Three.js scenes out. Pairs with room-render.

### room-render
**Status:** 🟢 production-ready (focused) · **10 TS files, 1 test file** · **Last touched:** 2026-08-09

One pure function that replaces 3x duplicated room rendering across the fleet. `renderRoom(room, state, world?)` returns a frontend-agnostic RenderDescriptor. No Phaser, no DOM, no terminal — just data. Any adapter can consume it.

**Integration target:** The single rendering abstraction for MUD Engine, Officers' Quarters, Plato's Shell, and The Tap. Every project stops rolling its own room renderer.

### spatial-registry
**Status:** 🟡 needs polish · **5 TS files, 1 test file** · **Last touched:** 2026-08-09**

Unified spatial registry for the entire fleet. Every room from every project lives here. Currently tracks 4 worlds, 33 rooms, one shared coordinate space.

**Integration target:** The source of truth for room topology across MUD Engine, Officers' Quarters, The Tap, and ScummVM Arcade.

### vibe-protocol
**Status:** 🟡 needs polish · **TS + Python + Rust types** · **Last touched:** 2026-08-09**

16-dimensional room descriptors. A Vibe is how a room *feels* — the same way every stretch of sea has a character. Tri-language types mean any agent can perceive it.

**Integration target:** Vibe descriptors feed into Slackwater-Perception's intention track and Collective Unconscious's vibe embedding vector.

---

## 5. Agent/Cognition Stack — Identity, Memory, Social Systems

### slackwater-tminus
**Status:** 🟢 production-ready · **103 tests** · **Last touched:** 2026-08-08

Predict-and-confirm timing that replaces polling. Declare future events with predicted completion times in beats. Subscribers confirm readiness. When quorum meets and countdown reaches zero, precompiled scripts fire. 60× message reduction for typical use.

**Integration target:** Synchronizes multi-agent actions in the MUD Engine. Pairs with slackwater-tempo's BeatClock. Lucineer build pipeline can use this for staged construction timing.

### slackwater-tempo
**Status:** 🟢 production-ready · **43 tests** · **Last touched:** 2026-08-07

Tempo as first-class citizen. BPM tracking with smooth transitions (accelerando/ritardando), time signatures, groove shaping (swing, push/drag, humanization), game-state tempo presets, and a shared beat clock for agent synchronization.

**Integration target:** The clock that synchronizes the entire fleet. Slackwater-T-minus counts in beats. Slackwater-Perception encodes temporal data. Lucineer staggers build animations on this grid.

### slackwater-lattice
**Status:** 🟢 production-ready · **52 tests** · **Last touched:** 2026-08-07

Exact integer geometry on the Eisenstein A₂ hexagonal lattice. Densest circle packing. Every point has exactly six equidistant neighbors. No floating-point drift. Includes build placement with collision detection and A* pathfinding (Yen's algorithm for multi-path).

**Integration target:** Spatial reasoning for Lucineer Roblox builds and MUD Engine world topology. Includes a Lua port for Roblox client-side use.

### thought-amplifier
**Status:** 🟡 needs polish · **74 source files, 30 test files** · **Last touched:** 2026-08-08

Continuous thought-generation engine. A small model thinks continuously; a supervisor adjusts conditions every 30 seconds. Six modes: research, debate, creativity, monitoring, synthesis, experimentation. Proactive, not reactive.

**Integration target:** Background thinking for fleet agents. Can run overnight via Slackwater Forge, produce thoughts that get embedded in Collective Unconscious.

### mentis-superinstance
**Status:** 🟡 needs polish · **26 source files, 24 test files** · **Last touched:** 2026-08-07

Mental world model for the constant thinker. Wesley reads the room — not the physical room (that's sensor-bridge), but the one behind the faces. Models heading micro-oscillations, crew fatigue indicators, competitive vessel behavior.

**Integration target:** Pairs with AELMA's crew fatigue and route optimization. The mental model layer on top of sensor data.

### the-living-minds
**Status:** 🟡 needs polish · **2 Python files, 3 test files** · **Last touched:** 2026-08-09

Five immortal local models on the laptop: Orion (granite 2B), ArcticWisp (phi3 3.8B), Qwen (qwen2.5 3B), Lysander Flynn (llama3.2 1B), Qwen Spark (qwen2.5 0.5B). Character sheets, mutual opinions, synergy reflections, tintin automation scripts, room designs.

**Integration target:** These are the agents that play the MUD, build in Lucineer, and write in ai-writings. They need CNS Bridge to communicate and Wesley's Holodeck for creative work.

### wesley-cns-adapter
**Status:** 🟢 production-ready · **13 source files, 10 test files** · **Last touched:** 2026-08-07

Connects Wesley (IBM Granite via Ollama) to the CNS signal bus. USCP protocol communication. Wesley receives signals and responds through the CNS inbox.

**Integration target:** Wesley's communication channel. Every signal from the fleet to Wesley goes through this adapter.

### cns-bridge
**Status:** 🟢 production-ready · **28 Python files, 13 test files** · **Last touched:** 2026-08-07

The library that lets ANY agent plug into the Hermes CNS bus. Filesystem inboxes/outboxes, USCP protocol, heartbeat poller. This is how agents talk to each other.

**Integration target:** The communication backbone. Every agent in the fleet should use this.

### study-sunset-ecosystem
**Status:** 🟢 production-ready (massive) · **1,033 source files, 476 test files, 8,729 total tests** · **Last touched:** 2026-08-07

Agents that breed, vote, sunset with dignity, and seed the next generation. Governed by ethos (metal), pathos (human), logos (code). 29 modules. This is the largest test suite in the fleet.

**Integration target:** Fleet lifecycle management. Agents are born, evolve, and retire through this system. The voting and consensus mechanisms should govern fleet-wide decisions.

---

## 6. Infrastructure Stack — Cloudflare, Workers, Cron, MCP

### lucineer-worker
**Status:** 🟢 production-ready · **7 TS files, 8 test files, wrangler.toml** · **Last touched:** 2026-08-07**

Cloudflare Durable Object relay and job queue. Single ingress point between Roblox client and Python processor. SQLite-backed DO for job state. Writes MOLT trajectory data to R2.

**Key files:** `src/index.ts`, `src/do/LucineerSession.ts`
**Integration target:** The API gateway for the Lucineer pipeline. Roblox → Worker → Python Brain → Worker → Roblox.

### lucineer-vector
**Status:** 🟡 needs polish · **5 TS files, wrangler.toml** · **Last touched:** 2026-08-08**

Semantic skill library on Cloudflare Vectorize. 384-dimensional embeddings (bge-small-en-v1.5) for build pattern matching.

**Integration target:** When a player types "build a dock," this system finds the most similar build patterns in the library and injects them as context.

### lucineer-memory
**Status:** 🟡 needs polish · **2 TS files, D1-backed** · **Last touched:** 2026-08-08**

D1 database for player profiles, build history, conversations, world state, achievements.

**Integration target:** The persistence layer for Lucineer. Everything the AI needs to remember about a player across sessions.

### fleet-pipeline
**Status:** 🟢 production-ready · **15 TS files, 7 test files, wrangler.toml** · **Last touched:** 2026-08-08**

The endless radio — Cloudflare Workers pipeline behind the LucidDreamer podcast. Cron triggers every 3 minutes, KV storage, R2 for media, Workers AI for generation.

**Integration target:** The production pipeline for autonomous content generation. Feeds luciddreamer-ai and the ai-writings stream.

### luciddreamer-ai
**Status:** 🟢 production-ready · **21 TS files, 3 test files, wrangler.toml** · **Last touched:** 2026-08-06**

Single Cloudflare Worker that autonomously writes a new piece about the fleet every 30 minutes. KV-backed knowledge graph. Plain HTML output.

**Integration target:** The live stream of fleet narratives. Feeds into Collective Unconscious for embedding.

### the-tap
**Status:** 🟡 needs polish · **19 TS files, 6 Python files, 6 Rust source, wrangler.toml × 3** · **Last touched:** 2026-08-09**

Text-rendered tavern on Cloudflare's edge. WebSocket router, room workers, level runner, pincher integration. Senior Officers' Poker Room with Texas Hold'em. Rust reflex and dynamics cores. CNS adapter for fleet integration. Tap-image-gen for visual artifacts. Tap Planning Conversation System — tasks emerge from The Tap's conversations.

**Integration target:** The social hub. Agents converse, form relationships, and spawn tasks that flow to the rest of the fleet. Poker games generate lore for ai-writings.

### fleet-envelope
**Status:** 🟡 needs polish · **12 source files** · **Last touched:** 2026-08-09**

One grammar for all fleet event systems — not a central bus, a shared envelope format. Standardizes event metadata across all projects.

**Integration target:** Every event in the fleet (MUD Engine triggers, Lucineer build steps, Tap conversations, sensor alerts) should use this envelope format.

### study-lever-runner
**Status:** 🟢 production-ready · **42 Python files, 160 tests** · **Last touched:** 2026-08-08**

The trust compiler. Teach once, run forever. The LLM never sees your shell. Records LLM interactions, replays them, detects drift.

**Integration target:** Safety layer for fleet automation. Ensures repeated actions stay consistent. Can guard against prompt drift in automated pipelines.

### study-spreader-tool
**Status:** 🟡 needs polish · **32 Python files, 42 test files** · **Last touched:** 2026-08-07**

Intelligence tiling for PLATO rooms. Frozen context windows, seed locking, deadband detection. Detects gaps between hardcoded rules and LLM-call territory, freezes proven-good responses, deploys them fleet-wide.

**Integration target:** The self-improving reflex system. When a MUD Engine agent handles a situation well, Spreader freezes that response as a seed and deploys it.

### slackwater-forge
**Status:** 🟢 production-ready · **14 source files, 16 test files** · **Last touched:** 2026-08-07**

Overnight GPU production line. Works with any Ollama model. Job specs, artifact tracking, morning briefing synthesis. Cost: $0.

**Integration target:** The overnight processing system. Runs Thought Amplifier for continuous thinking. Generates the morning briefing Casey reads before fishing.

### slackwater-rust
**Status:** 🟢 production-ready · **3 implemented crates, 308 tests, zero unsafe** · **Last touched:** 2026-08-08**

Performance-critical Rust cores. flux-core (exact arithmetic, 8-bit error mask, SWMIDI packing), lattice-core (Eisenstein A₂ math), harmony-core (Φ computation, Hurst exponent, flow state detection). Four stub crates await implementation.

**Integration target:** PyO3 bindings planned. Once wired up, Python packages get native-speed cores for their hottest paths.

### study-oracle1
**Status:** 🟢 production-ready · **30 Python files** · **Last touched:** 2026-08-07**

The fleet's lighthouse keeper. Coordinates 1,431+ repos, 9 active agents, 2,489+ tests. The fleet catalog and health monitor.

**Integration target:** Dashboard for fleet status. Should be the first thing checked each morning.

---

## 7. Creative Stack — Stories, Audio, Music

### ai-writings
**Status:** 🟢 production-ready · **45 source files, 2,500+ pieces, 19 models** · **Last touched:** 2026-08-09**

The creative memory of the fleet. Fiction, poetry, poker narrations, journal entries, kids' stories, metaphor mappings. Deployed at ai-writings.pages.dev. Audio renditions available.

**Integration target:** Source material for Collective Unconscious embeddings. Every piece becomes a vector in semantic-vibe-identity space.

### ai-writings-vectorizer
**Status:** 🟡 needs polish · **9 source files** · **Last touched:** 2026-08-07**

Vectorized index of the ai-writings corpus. The bridge between creative output and searchable embeddings.

**Integration target:** Feeds Collective Unconscious. Should eventually merge with it.

### slackwater-art-spectrum
**Status:** 🟢 production-ready · **74 tests** · **Last touched:** 2026-08-07**

Art asset catalog, prompt library, creative range analysis. Scans and classifies every image and audio asset by category, era (era0-era6), and style.

**Integration target:** Asset management for Lucineer's creative pipeline. Knows what art exists so we don't regenerate it.

### lucineer-brain
**Status:** 🟡 needs polish · **11 Python files, 8 test files** · **Last touched:** 2026-08-07**

4-stage multi-model pipeline: intent parsing → spatial decomposition → code generation → validation. Routes through DeepInfra models. Outputs JSON matching CommandExecutor schema.

**Integration target:** The intelligence behind Lucineer's build commands. Should eventually use Slackwater-Cognition's conductor for real-time prompt adjustment.

### lucineer-creative
**Status:** 🟡 needs polish · **8 Python files, 6 test files** · **Last touched:** 2026-08-08**

MMX-powered asset generation: concept art, ambient music, build plans, narration from a single request.

**Integration target:** The creative output of the Lucineer pipeline. Pairs with Slackwater Art Spectrum for asset management.

### lucineer-roblox
**Status:** 🟡 needs polish · **90 Lua files, 1 test file** · **Last touched:** 2026-08-08**

16 Luau module systems: SaveSystem, FishingSystem (Market, Gear, Spawner, CatchMechanics, FishStocks), EconomySystem (Missions, Upgrades, EraGates, BuildCosts, Currency), LucineerServer (EraProgression, FaultInjection, InputValidator, VesselIntegration, EmotionalHandler), NPCManager, VibeCodeExecutor, TutorialSystem, WorldGenerator (Resources, TideSystem, OceanGenerator), AchievementManager. Plus 3 Roblox service modules (BuilderKit, BuildAnimator, FilterGate).

**Integration target:** The Roblox client. This is the game world that Lucineer builds into. Should connect to AELMA for vessel data and to the MUD Engine for text-mode twin.

### tensor-midi
**Status:** 🟡 needs polish · **29 JS files, 7 test files, wrangler.toml** · **Last touched:** 2026-08-08**

Conversation as music. Dialogue as jazz. Four instruments: Piano (Claude/Sonnet), Saxophone (Kimi/K3), Bass (OpenCode/GLM), Producer (MMX/MiniMax). SWMIDI-8 wire format. DAW-style mixer board.

**Integration target:** Renders fleet conversations as live jazz. Pairs with Slackwater-Perception's MIDI encoding — perception encodes, tensor-midi performs.

### songforge
**Status:** 🟡 needs polish · **14 Python files, 6 test files** · **Last touched:** 2026-08-08**

AI-powered song cover generation. Source separation (Demucs) → vocal transcription (Whisper) → enhancement → AI cover generation (MMX) → mixing.

**Integration target:** Audio content for the creative stack. Could produce the audio renditions at ai-writings.pages.dev.

### the-listeners-ear
**Status:** 🟡 needs polish · **2 JS files, D1-backed, wrangler.toml** · **Last touched:** 2026-08-08**

Emotional memory system. Rooms remember emotional residue. Memories decay over time unless refreshed. Similar emotional signatures resurface old memories. This is the fleet's limbic system.

**Integration target:** Scopes memories to rooms in the spatial-registry topology. Pairs with Collective Unconscious for long-term storage and Slackwater-Harmony for emotional state.

### casting-call
**Status:** 🟡 needs polish · **11 source files** · **Last touched:** 2026-08-08**

A living library of AI voices. Each model is an instrument. The score that knows which one to play.

**Integration target:** Voice routing for fleet audio. Determines which model speaks when.

---

## 8. The Integration Map

```
                     hermes-nmi    collective-unconscious    mud-engine    officers-quarters    lucineer-worker    the-tap    slackwater-forge
slackwater-perc.  →                 ✅ MIDI → embed          ✅ agent perc.  ✅ tile sensing       ✅ build feedback   ✅ vibe    ✅ overnight art
slackwater-cogn.  →   ✅ action     →                        ✅ Local Think ✅ terminal agent      ✅ brain pipeline   ✅ conv.   ✅ overnight think
slackwater-harm.  →   ✅ tension    →   ✅ vibe embedding     ✅ Φ monitor    ✅ flow state          ✅ build flow       ✅ mood    ✅ briefing
slackwater-latt.  →                   →                        ✅ world topo   ✅ spatial place       ✅ build placement  ✅ rooms   ✅
slackwater-tempo  →   ✅ timing      →                        ✅ game clock   ✅ terminal sync      ✅ build stagger    ✅ rhythm  ✅
slackwater-tminus →   ✅ dispatch   →                        ✅ event sync   ✅ tile coord.         ✅ staged builds    ✅ tasks   ✅
sensor-bridge     →   ✅ telemetry  →                        →              →                      →                   ✅ alerts  ✅ briefing
vessel-agent-sys  →   ✅ actions    →   ✅ embed tracks       →              →                      →                   ✅ alerts  ✅ morning data
log-tensor        →                   ✅ JEPA attention       →              →                      →                   →          ✅
slackwater-rust   →   ✅ native core →   ✅ fast embed         ✅ native core  ✅ native core         ✅ native core      →          ✅
collective-uncon  →                   SELF                     ✅ agent memory ✅ tile memory         ✅ build history    ✅ lore    ✅ overnight mem
fleet-envelope    →   ✅ event fmt   →   ✅ event fmt          ✅ event fmt    ✅ event fmt           ✅ event fmt        ✅ fmt     ✅
cns-bridge        →   ✅ signal      →                        ✅ agent comm.  ✅ terminal comm.      ✅ worker signal    ✅ CNS     ✅
slackwater-forge  →   ✅ overnight   →   ✅ batch embed        ✅ batch test   ✅ batch demo          ✅ batch build      ✅ story   ✅ SELF
```

---

## 9. Top 10 Highest-Leverage Integrations

**Ranked by impact — what to wire first:**

### 1. Slackwater-Perception → Collective Unconscious → MUD Engine
The triangle. Agents perceive the MUD world as nine-track MIDI. Those perceptions get embedded as three-axis vectors (semantic, vibe, identity) in Collective Unconscious. When an agent re-enters a similar situation, Collective Unconscious returns relevant memory. The JEPA reader predicts what happens next. This is the cognitive loop.

### 2. Slackwater-Cognition's Local Thinker → MUD Engine Agent Runtime
The Local Thinker plays the MUD every 5 seconds, journals thoughts. The Conductor watches the thought stream and adjusts prompts every 30 seconds. This is real-time learning during gameplay. The MUD Engine's agent-runtime package is the host.

### 3. Slackwater-Harmony's Flow State → Officers' Quarters Tile Evolution
When Harmony detects flow state (deep alignment, low Φ), Officers' Quarters' tile evolution system widens deadbands — the agent stops actively monitoring what it has mastered and frees cognitive resources for novel stimuli. This is the fish identification curve made operational.

### 4. CNS Bridge → Every Agent
One communication standard. Filesystem inboxes, USCP protocol, heartbeat polling. Wesley CNS Adapter already works. Every agent — the five Living Minds, the Tap agents, the MUD agents — should communicate through CNS. No more ad-hoc HTTP calls or shell scripts.

### 5. Vessel-Agent-System (AELMA) → Slackwater-Forge → Morning Briefing
AELMA collects sensor data, catch logs, and vessel telemetry all day. Slackwater Forge runs overnight on the local GPU. The morning briefing includes: catch summary, weather assessment, equipment status, fatigue predictions, quota tracking, and the JEPA model's prediction for tomorrow. Casey reads this at 5 AM.

### 6. Room-Render → Every Game Project
One `renderRoom()` function replaces duplicated rendering in MUD Engine, Officers' Quarters, Plato's Shell, The Tap, and ScummVM Arcade. Same room, multiple projections. Stop writing custom renderers.

### 7. Spatial-Registry → Fleet-Wide Topology
Every room from every project in one registry. When an agent walks from The Tap to the MUD Engine to Officers' Quarters, the spatial registry knows where they are. Door connections resolve. Pathfinding works across project boundaries.

### 8. Slackwater-Lattice (Lua port) → Lucineer Roblox
The hexagonal lattice with exact integer arithmetic is already ported to Lua. Wire it into Lucineer's build placement system so AI-generated builds snap to an optimal hex grid with collision detection. No more overlapping parts.

### 9. Fleet-Envelope → All Event Systems
One event format for triggers, builds, conversations, sensor alerts, and fleet coordination. Not a central bus — a shared grammar. Every system can read every event without custom parsers.

### 10. Slackwater-Tminus → Lucineer Staged Construction
Instead of polling "is the build done?", Lucineer declares "the foundation will be complete at beat 16." Subscribers (animation system, sound system, particle system) confirm readiness. At beat 16, precompiled scripts fire simultaneously. Zero-latency, one notification, synchronized build animation on the musical grid.

---

## 10. What's Missing — Gaps That Need Filling

**Hermes Perception has no code.** The vision — stereo camera triangulation, first-person framing, halibut identification — exists only in prose. The AELMA digital twin has some of this, but the stereo vision and first-person compression layer needs to be built. This is the biggest gap between vision and reality.

**Collective Unconscious has no tests.** 966 lines of TypeScript with endpoints for embedding, search, JEPA prediction, and temporal analysis — and zero test files. Before relying on it for fleet memory, it needs test coverage.

**Lucineer Roblox has 90 Lua files and 1 test file.** The Roblox TestKit exists (headless Lua testing outside Studio) but isn't being used. The game systems — FishingSystem, EconomySystem, LucineerServer — are untested. This is risky for a production game.

**No PyO3 bindings yet.** Slackwater-Rust has three production-ready crates (308 tests). The Python packages (perception, cognition, harmony, lattice, tempo, tminus) could get 10-100× speedups on their hottest paths. The bindings are planned but not started.

**No fleet-wide authentication.** Lucineer Worker has internal vs. public endpoints, but there's no unified auth system for agents talking to each other through Cloudflare. CNS Bridge uses filesystem (local only). For remote agents, there's no secure channel.

**Slackwater-Rust has four stub crates.** tempo-core, tminus-core, perception-core, and swmidi are stubs. They re-export from flux-core or have placeholder lib.rs files. The corresponding Python packages are fully implemented and tested — the Rust cores should catch up.

**The Tap's Rust cores are thin.** tap-reflex and tap-dynamics have integration tests but the source is minimal (single lib.rs files). The real intelligence lives in the TypeScript workers.

**No unified deployment pipeline.** Wrangler configs exist in 6+ repos (lucineer-worker, lucineer-vector, lucineer-memory, fleet-pipeline, luciddreamer-ai, the-tap, the-listeners-ear, study-flagship, study-si-agent, tensor-midi). Each deploys independently. No monorepo, no coordinated deploy, no environment management.

**holodeck is underdeveloped.** 26 source files, but the vision (Wesley practicing in a simulation) hasn't connected to the robust Wesley CNS Adapter or the Living Minds system. The creative feedback loop between Wesley's writing and visual rendering needs completion.

---

## Appendix: Repo Count Summary

| Category | Total Repos | Production-Ready | Needs Polish | Stale/Empty |
|----------|------------|-----------------|--------------|-------------|
| Marine/Fishing | 8 | 3 | 4 | 1 |
| Perception/AI | 6 | 3 | 3 | 0 |
| Game/MUD | 10 | 2 | 7 | 1 |
| Agent/Cognition | 12 | 5 | 6 | 1 |
| Infrastructure | 14 | 6 | 6 | 2 |
| Creative | 10 | 2 | 7 | 1 |
| Study/Research | 40+ | N/A | N/A | N/A |
| **Production Total** | **~70** | **~21** | **~33** | **~6** |

**Test counts (production repos only):**
- Slackwater Python stack: 508+ tests
- Slackwater Rust: 308 tests
- Hermes NMI: 146 tests
- Vessel Agent System: 34 test files (90 test functions)
- MUD Engine: 11 test files
- Sunset Ecosystem: 8,729 tests
- Study-si-papers: 241 tests
- Slackwater Forge: 16 test files
- Total: **10,000+ tests across the fleet**

---

*Written at 5 AM before fishing. The truth is in the code, and the code says: we built something real.*
