# DEEP REPO ASSESSMENT — Code-Level Integration Plans

**Date:** August 9, 2026
**Scout:** Subagent (GLM-5.2)
**Method:** Read actual source code (not READMEs) for 10 high-value repos
**Purpose:** Specific, actionable integration plans with file paths and function signatures

---

## Executive Summary

After reading the actual code across all 10 repos, here's the honest picture:

**Immediate deploy (we're stupid not to):**
1. **batten-spline** — Self-improving model router with 131 tests. It's literally built to replace our ad-hoc "use DeepSeek for X, GLM for Y" decisions. `CascadeRouter.route(embedding) → RouteResult`. This should be wiring mud-engine's strategy-guild TODAY.
2. **casting-call** — The role-to-model mapping we maintain manually in TOOLS.md. `cast("intent_parse") → "SEED_MINI"`. Already has our exact model lineup encoded. One import replaces a wall of mental routing.
3. **confidence-cascade** — Mathematical confidence framework. `sequentialCascade([confidences]) → CascadeResult`. Every multi-step pipeline should cascade its confidence.

**High-value, moderate effort:**
4. **slackwater-perception** — The MIDI encoder is real, tested, and the `encode_game_state()` method is exactly what mud-engine agents need. The `IntentionPropagator` is literally a pre-event prediction system.
5. **thought-amplifier** — Six thinking modes with a working overnight runner. The `run_overnight.py` script already generates morning briefings. It's a turnkey background cognition engine.
6. **cns-bridge** — Working, tested, filesystem-based signal bus. The `Agent` class and `FileSystemTransport` are immediately usable. Every new system should wire through it.

**Significant but research-heavy:**
7. **stigmergy** — Bio-inspired pheromone coordination. Works as advertised but needs a spatial topology (room adjacency) to propagate through. Pairs with spatial-registry.
8. **log-tensor** — Missile-guidance attention. The math is legitimate (PN guidance + Kalman filtering + geometric algebra). But it's research code — no production wiring, pure NumPy.
9. **forgemaster** — A research flywheel + grimoire (spell book vector DB). The flywheel auto-generates CUDA experiments. The grimoire stores executable scripts as invocable spells. Niche but powerful.
10. **study-sunset-ecosystem** — 8,729 tests across an enormous codebase. Contains working JEPA, metronome, consensus, room grid, and breeding systems. But it's a research ecosystem, not a library — extraction is significant.

**One surprise:** forgemaster's grimoire is a genuinely novel idea — a vector DB that stores OUTPUTS (executable scripts) indexed by "magic words," not inputs. This is the opposite of Collective Unconscious and fills a gap we didn't know we had.

---

## 1. slackwater-perception — The MIDI Encoder

### What the Code ACTUALLY Does

`MultiTrackEncoder` accepts audio frames, text, or game state dicts and produces a 9-track MIDI file. Each track captures one perceptual dimension: pitch, tempo, velocity, timbre, inflection, silence, gesture, intention, attention.

The critical method is `encode_game_state(state, tick)`:
```python
# Player position → pitch (higher Y = higher note)
# Action intensity → velocity (idle=0.15, attack=1.0)
# Interaction type → gesture (look_at, nod, point, trade, hold)
# Pending action → intention (pre-event propagation)
# Focus target → attention (weighted spotlight)
```

This is not metaphorical — it literally converts game state to MIDI events with proper tick timing.

### Three Most Important Classes/Functions

1. **`MultiTrackEncoder.encode_game_state(state: dict, tick: int)`** — The primary integration point. Feed it `{"player_x": 10, "player_y": 5, "action": "walk", "focus_target": "npc:fisherman"}` and it produces synchronized events across 9 tracks.

2. **`IntentionPropagator.predict_from_game_state(state: dict) → IntentionSignal`** — Detects pre-event cues. Returns `{strength, description, predicted_event, ticks_until}`. This is forward-looking perception — what's ABOUT to happen.

3. **`AttentionTracker.set_focus(target: str, weight: float)`** — Models attention as weighted foci with inertia and locking. Attention can be narrow (one focus at 0.9+), broad (multiple foci), or locked (resistant to shifting).

### How It Connects to What We Built

- **hermes-perception** (currently empty) should import slackwater-perception directly. The `encode_game_state()` method IS the perception layer.
- **collective-unconscious** — perception outputs get embedded as vectors. MIDI tracks → embed → search → JEPA prediction.
- **mud-engine** — the `triggers` package should emit game state dicts that perception encodes.

### Integration Plan

```python
# In hermes-perception/src/perception.py (NEW FILE)
from slackwater_perception.encoder import MultiTrackEncoder, TrackType
from slackwater_perception.intention import IntentionPropagator
from slackwater_perception.attention import AttentionTracker

class HermesPerception:
    def __init__(self):
        self.encoder = MultiTrackEncoder()
        self.intention = IntentionPropagator()
        self.attention = AttentionTracker()
    
    def perceive(self, game_state: dict) -> dict:
        """Convert mud-engine game state to perception data."""
        tick = self.encoder.current_tick
        self.encoder.encode_game_state(game_state, tick)
        
        intention = self.intention.predict_from_game_state(game_state)
        attention = self.attention.update_from_game_state(game_state)
        
        return {
            "midi_tracks": self.encoder.to_dict(),
            "intention": intention.__dict__,
            "attention": self.attention.describe(),
        }
```

**File paths:**
- Source: `/home/eileen/projects/slackwater-perception/slackwater_perception/{encoder,attention,intention}.py`
- Target: `/home/eileen/projects/hermes-perception/src/perception.py` (new)

**Effort:** 4-6 hours (wrapper + tests)
**Priority:** HIGH — this is the perception layer the fleet has been missing

---

## 2. batten-spline — The Self-Improving Model Router

### What the Code ACTUALLY Does

Three layers of abstraction:

1. **`Batten`** — A verified anchor point in embedding space. `prompt_embedding + quality_score + timestamp + half_life`. Age decays exponentially: `weight = 0.5^((now - ts) / half_life)`.

2. **`BattenSpline`** — Nadaraya-Watson kernel regression over battens. For a new prompt embedding, computes distance-weighted confidence: `confidence = Σ(age_w × exp(-dist²/2σ²) × quality) / Σ(age_w × exp(-dist²/2σ²))`. Also computes `fog_density` (distance to nearest batten — higher = more uncertain).

3. **`CascadeRouter`** — Turns spline confidence into routing decisions. Configurable targets with thresholds:
   ```python
   DEFAULT_TARGETS = {
       "LOCAL":    {"threshold": 0.7},  # local model reliable here
       "CASCADE":  {"threshold": 0.3},  # try local, escalate if weak
       "CLOUD":    {"threshold": 0.0},  # unfamiliar — go straight to cloud
   }
   ```

The system LEARNS. After each call, `router.report_outcome(embedding, quality)` adds a new batten. Over time, the spline map fills in and routing becomes more accurate.

### Three Most Important Functions

1. **`CascadeRouter.route(embedding: np.ndarray) → RouteResult`** — The primary call. Returns `{target, confidence, fog_density, reason}`. One function call replaces our entire mental model of "use DeepSeek for X."

2. **`CascadeRouter.report_outcome(embedding, quality, metadata)`** — The learning loop. After the model responds, score the quality (0-1) and the spline grows.

3. **`BattenSpline.routing_decision(confidence) → "LOCAL"|"CASCADE"|"CLOUD"`** — Three-zone routing. But the targets are configurable — we can set them to `"DEEPSEEK"|"GLM"|"CLAUDE"`.

### How It Connects to What We Built

The mud-engine's `strategy-guild` package currently has no model routing logic. Our TOOLS.md has a hand-maintained routing table. Batten-spline replaces both with a self-improving system.

### Integration Plan

```python
# In mud-engine/packages/strategy-guild/src/router.ts (NEW)
// Or as a Python sidecar that the TS packages call via subprocess

from batten_spline.router import CascadeRouter, RouteResult
from batten_spline.spline import BattenSpline
import numpy as np

# Configure for our model lineup
router = CascadeRouter(
    spline=BattenSpline(fog_scale=1.0, half_life=604800.0),  # 1 week decay
    targets={
        "GLM_5_2":      {"threshold": 0.7, "description": "unlimited tokens, cheap"},
        "DEEPSEEK":     {"threshold": 0.4, "description": "nearly free, high quality"},
        "CLAUDE":       {"threshold": 0.0, "description": "expensive, reserve for hard"},
    }
)

def route_prompt(prompt_text: str, embedding: np.ndarray) -> str:
    result = router.route(embedding)
    if result.fog_density > 2.0:
        # Uncharted territory — use cheapest model to probe
        return "DEEPSEEK"
    return result.target

def record_outcome(prompt_text: str, embedding: np.ndarray, quality: float):
    router.report_outcome(embedding, quality, metadata={"prompt": prompt_text[:200]})
```

**File paths:**
- Source: `/home/eileen/projects/batten-spline/src/batten_spline/{router,spline,batten}.py`
- Target: `/home/eileen/projects/mud-engine/packages/strategy-guild/src/model-router.ts` (new, or Python sidecar)
- State persistence: `/home/eileen/.openclaw/workspace/batten-state.json`

**Effort:** 3-4 hours (import, configure targets, wire to strategy-guild)
**Priority:** CRITICAL — this replaces manual routing with a learning system

---

## 3. thought-amplifier — The Overnight Runner

### What the Code ACTUALLY Does

A continuous thought-generation engine with six specialized modes. The code is substantial:

- **`modes/advocate.py`** — Devil's advocate. Takes a claim, generates counter-arguments from 6 strategies (empirical, logical, practical, moral, historical, systemic), then identifies the meta-vulnerability.
- **`modes/watcher.py`** — Monitoring mode. Watches URLs/data streams for changes.
- **`modes/simulator.py`** — Simulation mode. Runs thought experiments.
- **`modes/reporter.py`** — Summarizes and reports.
- **`modes/connector.py`** — Finds connections between disparate ideas.
- **`modes/mirror.py`** — Self-reflection mode.
- **`modes/common.py`** — Shared LLM calling (GLM first, DeepSeek fallback). Already wired to our exact API endpoints.

The `run_overnight.py` script is a complete overnight pipeline:
- Rotates through 4 domains: roblox, maritime, cognition, digital-twin
- 5 iterations per domain (20 total)
- Generates a morning briefing with stats (help rate, avg delta, reflexes compiled)
- Watchdog monitors Ollama health, auto-restarts on crash
- Briefings saved to `/home/eileen/.openclaw/workspace/memory/night-watch/`

### Three Most Important Components

1. **`run_overnight.py::generate_briefing()`** — The morning briefing generator. Already writes to our workspace memory directory. Includes per-domain breakdown, help rates, surprises, watchdog events.

2. **`Advocate.argue(claim, num_arguments)`** — Steel-man counter-argument generator. Six orthogonal strategies + meta-vulnerability analysis. This is the "debate" thinking mode.

3. **`common.py::llm_call()`** — Shared LLM caller with GLM→DeepSeek fallback. Already configured for our exact API keys and endpoints. Every mode uses this.

### How It Connects to SMP Notebook

The SMP notebook's `smp-self.ts` defines self-observation types: `IdentitySnapshot`, `TileSummary`, `ShellSummary`. These are the inward-facing mirrors of thought-amplifier's outward-facing modes.

The connection:
- thought-amplifier's **advocate mode** → SMP's "debate" self-observation type
- thought-amplifier's **watcher mode** → SMP's "monitoring" self-observation type  
- thought-amplifier's **simulator mode** → SMP's "experimentation" self-observation type
- thought-amplifier's **mirror mode** → SMP's "reflection" self-observation type

### Integration Plan

```typescript
// In smp-notebook/src/thought-amplifier-bridge.ts (NEW)

import { ThoughtMode } from './types.js';
// Spawn thought-amplifier as a subprocess

export interface ThoughtResult {
  mode: ThoughtMode;
  entries: Array<{content: string; metadata: Record<string, unknown>}>;
  timestamp: string;
}

export async function runThoughtMode(
  mode: ThoughtMode,
  claim: string,
  iterations: number = 4
): Promise<ThoughtResult> {
  // Call thought-amplifier's Python modes via subprocess
  const script = `/home/eileen/projects/thought-amplifier/modes/${mode}.py`;
  // ... spawn python, parse JSON output
}
```

For the overnight runner, it's already wired to write briefings to our workspace. We just need to add it to the heartbeat/cron schedule:

```bash
# crontab entry
0 22 * * * cd /home/eileen/projects/thought-amplifier && python3 run_overnight.py --iterations 5
```

**File paths:**
- Source: `/home/eileen/projects/thought-amplifier/{run_overnight.py,modes/*.py}`
- Target: `/home/eileen/projects/smp-notebook/src/thought-amplifier-bridge.ts` (new)
- Briefing output: `/home/eileen/.openclaw/workspace/memory/night-watch/YYYY-MM-DD-night.md`

**Effort:** 2-3 hours (bridge + cron setup + test run)
**Priority:** HIGH — overnight thinking is free compute

---

## 4. confidence-cascade — Multi-Model Confidence Scoring

### What the Code ACTUALLY Does

A TypeScript confidence composition framework with three composition primitives:

1. **`sequentialCascade(confidences[])`** — Confidence MULTIPLIES through a chain. Five steps at 90% each → 0.9^5 = 0.59 → RED zone. This tells you your pipeline is too long.

2. **`parallelCascade(branches[])`** — Confidence AVERAGES with weights. Three validators at 50%/30%/20% weighting.

3. **`conditionalCascade(paths[])`** — Exactly one path active. Confidence depends on which branch was taken.

Three-zone model: GREEN ≥ 0.90 (full steam), YELLOW 0.75-0.89 (caution), RED < 0.75 (stop). Escalation levels: NONE → NOTICE → WARNING → ALERT → CRITICAL.

The code includes a complete fraud detection example showing how to compose parallel + conditional + sequential cascades.

### Three Most Important Functions

1. **`sequentialCascade(confidences: Confidence[])`** — Pipeline confidence. Every multi-step pipeline should wrap its confidence in this.

2. **`parallelCascade(branches: ParallelBranch[])`** — Multi-model voting. When GLM, DeepSeek, and Claude all attempt something, their confidences compose here.

3. **`createConfidence(value: number, source: string)`** — Factory. Every decision point creates a Confidence, then they cascade.

### How It Connects to the Emergence Engine

The emergence engine's `PredictabilityEstimator` in `emergence-detector.ts` asks: "could any ONE agent have produced this?" The answer is a confidence value. That confidence should cascade:

```typescript
// In emergence-engine/src/confidence-bridge.ts (NEW)
import { sequentialCascade, parallelCascade, createConfidence } from 'confidence-cascade';

// For each emergent pattern:
const individualConfidences = agents.map(agent => 
  createConfidence(
    predictabilityEstimator.score(event, agent),
    `agent:${agent.id}`
  )
);

// Parallel: could any individual have produced this?
const parallelResult = parallelCascade(
  individualConfidences.map((conf, i) => ({
    confidence: conf,
    weight: agentWeights[i]
  }))
);

// Sequential: is the pattern itself reliable?
const finalResult = sequentialCascade([
  parallelResult.confidence,
  createConfidence(patternStrength, 'pattern_detector'),
  createConfidence(contextualFit, 'context_scorer')
]);

if (finalResult.confidence.zone === 'GREEN') {
  // Confident emergence — tag it
} else if (finalResult.escalationTriggered) {
  // Low confidence — flag for review
}
```

**File paths:**
- Source: `/home/eileen/projects/confidence-cascade/src/confidence-cascade.ts`
- Target: `/home/eileen/projects/emergence-engine/src/confidence-bridge.ts` (new)
- npm package: already built with dist/

**Effort:** 2 hours (import + wire to emergence detector)
**Priority:** HIGH — the emergence engine needs confidence scoring to function

---

## 5. casting-call — Knows Which AI Model to Use for Which Role

### What the Code ACTUALLY Does

A two-layer system:

**Layer 1: `ModelAtlas`** — A database of model profiles. Each profile has: name, voice_character, cost_per_1k_tokens, strengths, tempo_bpm, failure_modes. The default atlas already includes our exact model lineup: SEED_MINI, SEED_PRO, QWEN3_CODER, HERMES_405B, NEMOTRON_ULTRA, GLM_5_2, DEEPSEEK_V4_FLASH, CLAUDE_SONNET, etc.

**Layer 2: `CastingDirector`** — Given a role name, returns the best model. Has fallback chains:
```python
_ROLE_FALLBACKS = {
    "intent_parse":      ["SEED_MINI", "GLM_5_2", "DEEPSEEK_V4_FLASH"],
    "code_gen":          ["QWEN3_CODER", "DEEPSEEK_V4_FLASH", "CLAUDE_SONNET"],
    "personality_wrap":  ["HERMES_405B", "GLM_5_2"],
    "safety_check":      ["NEMOTRON_ULTRA", "CLAUDE_OPUS"],
    # ... 13 roles total
}
```

The `counterpoint_check()` enforces no parallel octaves — two adjacent pipeline stages can't use the same model. The `what_if()` method does cost/tempo analysis for model swaps.

The `pipeline.py` module provides the simplest possible API:
```python
from casting_call.pipeline import cast
model_name = cast("intent_parse")  # → "SEED_MINI"
```

### Three Most Important Functions

1. **`CastingDirector.cast(role, context) → ModelProfile`** — The primary call. Returns full profile with temperature, voice character, cost, tempo range.

2. **`CastingDirector.cast_pipeline(roles[]) → ModelProfile[]`** — Cast an entire pipeline at once. Enforces counterpoint (no adjacent duplicate models).

3. **`cast(role) → str`** (from pipeline.py) — The one-liner. `cast("code_gen")` → `"QWEN3_CODER"`.

### How It Connects to ZeroClaw

ZeroClaw's `lifecycle.ts` defines a model progression:
```
MODEL_PROGRESSION: rules → ollama → deepinfra → deepseek
```

A ZeroClaw agent starts with rules-only (no API calls), earns ollama access, then deepinfra, then deepseek. Currently this progression has no intelligence about WHICH model to use for WHICH task.

Casting-call fills this gap:
```python
# When a ZeroClaw agent reaches a model tier, casting-call picks the model
from casting_call.pipeline import cast

# ZeroClaw reaches "deepinfra" tier:
model = cast("intent_parse")  # → "SEED_MINI" (a DeepInfra model)
model = cast("code_gen")      # → "QWEN3_CODER" (another DeepInfra model)
```

### Integration Plan

```typescript
// In zeroclaw/src/casting-bridge.ts (NEW)
// Calls casting-call's Python via subprocess

import { spawnSync } from 'child_process';

export function castModel(role: string, context?: {
  costCeiling?: number;
  exclude?: string[];
  preferSpeed?: boolean;
}): string {
  const args = ['-c', `
from casting_call.pipeline import cast
print(cast("${role}", ${JSON.stringify(context || {})}))
  `];
  const result = spawnSync('python3', args, { cwd: '/home/eileen/projects/casting-call' });
  return result.stdout.toString().trim();
}
```

For the model progression in lifecycle.ts:
```typescript
// When promoting a ZeroClaw agent, use casting-call to pick the specific model
function selectModelForTier(tier: ModelTier, taskType: string): string {
  if (tier === 'rules') return 'rules';
  if (tier === 'ollama') return 'granite3.1-dense:2b';
  if (tier === 'deepinfra') return castModel(taskType);  // casting-call decides
  if (tier === 'deepseek') return 'deepseek-chat';
  return 'rules';
}
```

**File paths:**
- Source: `/home/eileen/projects/casting-call/casting_call/{casting,pipeline,atlas}.py`
- Target: `/home/eileen/projects/zeroclaw/src/casting-bridge.ts` (new)
- Also update: `/home/eileen/projects/zeroclaw/src/lifecycle.ts` (modify model selection)

**Effort:** 3 hours (bridge + lifecycle integration)
**Priority:** HIGH — gives ZeroClaw agents intelligent model selection

---

## 6. log-tensor — Guidance-System Transformers

### What the Code ACTUALLY Does

Two implementations of geometric attention:

**HGT (Homing Geometric Transformer)** in `hgt_research.py`:
- Treats attention as a missile guidance problem
- `LineOfSight` class computes LOS vectors and rotation rates between current understanding and target meaning
- `PNGuidance` implements proportional navigation: `a_cmd = N × Vc × λ̇` (navigation constant × closing velocity × LOS rate)
- `KalmanFilter` filters noisy observations to estimate true semantic state
- `HomingGeometricTransformer` combines all three: filter observations → compute LOS → generate guidance command → adjust attention → check for "intercept" (certainty threshold)
- `AdaptiveReasoningController` shortens reasoning loops as certainty increases: `depth = max_depth × (1 - certainty)^α`

**UGT (Unified Geometric Transformer)** in `ugt.py`:
- Single equation: `Attention(Q,K,V) = softmax(⟨Q,K⟩ + ω·(Q∧K)) V`
- Based on Clifford Algebra Cl(3,0)
- `GeometricProduct`: inner (scalar, rotation invariant) + outer (bivector, rotation plane)
- `BivectorConnection`: learned parameter ω that encodes geometric structure
- Optional: Chern-Simons topological regularizer, RG flow scheduler, q-deformation

The math is legitimate. This is not vaporware — it's implemented and testable.

### Three Most Important Components

1. **`HomingGeometricTransformer.homing_step()`** — Single iteration of the homing loop. Returns dict with filtered_state, LOS, drift_rate, convergence_rate, guidance_command, certainty, reasoning_depth, intercept boolean.

2. **`KalmanFilter.update(measurement) → (state, innovation)`** — Filters noisy observations. Innovation magnitude is useful for anomaly detection (large innovation = surprising observation).

3. **`AdaptiveReasoningController.update_depth(certainty) → int`** — Reduces computation as confidence rises. `depth = max_depth × (1 - certainty)^2`.

### The JEPA Connection for Fish Identification

The HGT's homing sequence IS a prediction mechanism. For fish ID:

1. **Target** = the true fish species embedding
2. **Observations** = noisy sensor data (camera frames, sonar returns)
3. **Kalman filter** denoises the observations
4. **Proportional navigation** adjusts attention toward the correct species
5. **Certainty threshold** = "I know what this fish is"

```python
# In vessel-agent-system/src/fish_id/jepa_predictor.py (NEW)
from logtensor.transforms.hgt_research import (
    HomingGeometricTransformer, KalmanFilter,
    AdaptiveReasoningController
)

class FishIDPredictor:
    def __init__(self, species_embeddings: dict[str, np.ndarray]):
        self.hgt = HomingGeometricTransformer(
            dim=64,  # embedding dimension
            navigation_constant=4.0,
            min_certainty_threshold=0.85,
            max_iterations=8,
        )
        self.species_embeddings = species_embeddings
    
    def identify(self, observations: list[np.ndarray]) -> dict:
        results = {}
        for species, target_embedding in self.species_embeddings.items():
            result = self.hgt.full_homing_sequence(
                initial_observation=observations[0],
                target=target_embedding,
                observation_stream=observations
            )
            results[species] = result['final_certainty']
        
        best_species = max(results, key=results.get)
        return {
            'species': best_species,
            'confidence': results[best_species],
            'all_scores': results,
        }
```

**File paths:**
- Source: `/home/eileen/projects/log-tensor/logtensor/transforms/{hgt_research,ugt}.py`
- Target: `/home/eileen/projects/vessel-agent-system/src/fish_id/jepa_predictor.py` (new)

**Effort:** 1-2 days (need species embeddings + tuning navigation constant)
**Priority:** MEDIUM — research-grade, needs validation against real data

---

## 7. stigmergy — Bio-Inspired Pheromone Coordination

### What the Code ACTUALLY Does

A TypeScript implementation of stigmergic coordination:

**`Stigmergy`** class — The environment where agents deposit and detect pheromone signals.
- `deposit(sourceId, type, position, strength)` — Leave a pheromone signal
- `detect(position, types?) → {nearby, strongest}` — Sense nearby pheromones
- `follow(pheromoneId, followerId)` — Reinforce an existing trail
- `evaporate()` — Decay all pheromones by half-life (called on timer)
- `reset()` — Clear all signals

Five pheromone types: PATHWAY, RESOURCE, DANGER, NEST, RECRUIT.

Position can be: coordinate-based (`[x, y]`), topic-based (`"fishing-strategy"`), task-type-based, or context-hash-based. This is key — it works in conceptual space, not just physical space.

**`TrailFollower`** class — Agent-oriented wrapper.
- `followTrail(currentPosition, targetType) → {found, pheromone, direction}`
- `leaveSignal(type, position, strength)`

### Three Most Important Components

1. **`Stigmergy.deposit(sourceId, type, position, strength)`** — The write operation. An agent leaves a signal in the environment.

2. **`Stigmergy.detect(position, types?) → {nearby, strongest}`** — The read operation. An agent senses what's around it.

3. **`Stigmergy.follow(pheromoneId, followerId)`** — Reinforcement. Following a trail makes it stronger.

### How Vibes Flow Through Room Adjacency

The vibe-protocol defines 16-dimensional room descriptors. The spatial-registry tracks room topology (adjacency). Stigmergy is the propagation mechanism:

```typescript
// In vibe-protocol/src/propagation.ts (NEW)
import { Stigmergy, PheromoneType, TrailFollower } from 'stigmergy';

const vibeField = new Stigmergy({
  maxPheromones: 5000,
  defaultHalfLife: 300000,  // 5 minutes
  evaporationInterval: 30000,
  detectionRadius: 0.5,
});

// When something exciting happens in a room, deposit a vibe
function emitVibe(roomId: string, vibe: Vibe, strength: number) {
  const position = { topic: roomId };
  vibeField.deposit(roomId, PheromoneType.RESOURCE, position, strength,
    new Map([['vibe', vibe], ['timestamp', Date.now()]]));
}

// Adjacent rooms sense the vibe
function senseAdjacentVibes(roomId: string, adjacentRoomIds: string[]) {
  const allNearby = [];
  for (const adjId of adjacentRoomIds) {
    const detected = vibeField.detect({ topic: adjId });
    if (detected.strongest) {
      // Propagate: deposit a weaker signal in this room
      vibeField.deposit(
        roomId, detected.strongest.type,
        { topic: roomId },
        detected.strongest.strength * 0.6,  // decay across boundary
        detected.strongest.metadata
      );
    }
  }
}
```

**File paths:**
- Source: `/home/eileen/projects/stigmergy/src/stigmergy.ts`
- Target: `/home/eileen/projects/vibe-protocol/src/propagation.ts` (new)
- Depends on: spatial-registry for adjacency data

**Effort:** 4-6 hours (propagation logic + spatial-registry integration)
**Priority:** MEDIUM — powerful but needs the spatial topology to be useful first

---

## 8. forgemaster — What IS This?

### What the Code ACTUALLY Does

Forgemaster is two things:

**1. Discovery Flywheel** (`.keeper/flywheel.py`) — An automated research loop:
- Maintains a list of OPEN_QUESTIONS (CT snap properties, DCS convergence, MUD architecture)
- For each question: asks an LLM to design a CUDA experiment → compiles and runs it on the GPU → asks LLM to evaluate the result → queues follow-up questions
- Rotates through models (DeepSeek, Qwen, Llama) for diverse experiment designs
- Logs everything to `/tmp/forgemaster/flywheel/`

**2. Grimoire / Spell Book** (`.keeper/grimoire/grimoire.py`) — A vector DB that stores OUTPUTS, not inputs:
- Traditional vector DB: embed inputs, retrieve similar memories
- Grimoire: embed executable scripts, retrieve by "magic word"
- Each "spell" is a complete script: CUDA kernel, Python utility, shell procedure, mad-lib template, situation-room playbook
- `inscribe(name, incantation, school, scroll)` — Add a spell
- `invoke(incantation) → {name, school, level, scroll}` — Retrieve by magic word
- `search(query)` — Fuzzy match via FAISS
- Already populated with spells for CT snap benchmarks, MUD connection, fleet operations

The grimoire also supports "spell books" — collections of related spells invoked together.

### Three Most Important Components

1. **`SpellBook.invoke(incantation) → dict`** — The magic word API. `invoke("ct-snap-throughput")` returns the full CUDA kernel. No prompt engineering, no ambiguity.

2. **`flywheel_loop(iterations)`** — The discovery engine. Question → CUDA experiment → GPU run → evaluate → next question. Falsification narrows the search space.

3. **`SpellBook.search(query, school?, level_max?)`** — Fuzzy search for spells by content. Uses FAISS for vector similarity.

### Can We Use It?

Yes, but it's niche. The grimoire concept is powerful for fleet operations — it's a library of proven scripts that agents can invoke by name. The flywheel is useful for automated research but requires a CUDA GPU.

The grimoire should become the fleet's shared procedure library:
```python
# Any agent can invoke a spell
from grimoire import SpellBook
book = SpellBook()
result = book.invoke("mud-connect")  # Returns the MUD connection script
result = book.invoke("beachcomb")    # Returns the fleet monitoring script
```

### Integration Plan

- **Grimoire** → Move to `/home/eileen/.openclaw/workspace/grimoire/` as the fleet spell library
- **Flywheel** → Schedule via cron for overnight research runs
- **Integration with casting-call** → When casting-call picks a model, the grimoire provides the proven prompt template for that model

**Effort:** 1 day (extract from forgemaster, populate fleet spells)
**Priority:** MEDIUM — useful infrastructure but not blocking

---

## 9. study-sunset-ecosystem — The Biggest Test Suite in the Fleet

### What the Code ACTUALLY Does

This is not one system — it's an entire research ecosystem. Reading the actual modules:

**`nerve/`** — Neural grid system
- `jepa.py` — Working minimal JEPA model (3.4K params) with chaos-engineered routing. `MinimalJEPA` class: encoder + predictor. `JEPAFiber` wraps it with signal processing. `JEPASwarm` manages multiple fibers learning different latent spaces for the same signal.
- `metronome.py` — Beat-driven scheduler. `MetronomeScheduler` wraps `RoomGrid.tick()` in a tempo-driven loop. Each beat = one grid tick. Pluggable signal sources (random, A2A agent, etc.). Routing, breeding, and FLUX checks fire on sub-multiples of the beat.
- `room_grid.py` — The spatial grid that rooms live on
- `topology.py` — Room adjacency and network topology
- `routing.py` — Signal routing between rooms

**`nexus/`** — Coordination layer
- `distributed_consensus.py` — PBFT-style consensus with H¹ cohomology emergence detection. `HolonomyConsensus` class: `propose_state_change()`, `commit_if_quorum()`. Tolerates Byzantine faults (f < N/3).
- `holonomy_bridge.py` — Connects local operations to fleet-wide consensus

**`ethos/`** — Hardware/agent allocation
- `agent_allocator.py` — Allocates agents to hardware based on thermal/compute constraints
- `thermal_auto_calibrate.py` — Auto-calibrates based on thermal sensors
- `trinity_connection.py` — Connects ethos (metal), pathos (human), logos (code)

**`plato_core/`** — Core types
- `types.py` — `LamportClock`, `TileLifecycle`, `TrainingTile`, `TileType` (checkpoint, prediction, evaluation, metrics, decision, episteme)

**`claw_fleet_bridge.py`** — HTTP API exposing everything to Claw. REST endpoints: `/breed`, `/flux/check`, `/mesh/insert`, `/mesh/query`, `/health`, `/status`.

### Three Most Important Extractable Components

1. **`MinimalJEPA` + `JEPAFiber` + `JEPASwarm`** from `nerve/jepa.py` — Working JEPA with chaos routing. Each fiber learns a DIFFERENT latent space. The chaos engine compares these and routes novelty. This is directly usable in collective-unconscious.

2. **`MetronomeScheduler`** from `nerve/metronome.py` — Beat-driven room grid ticking. Integrates with `RoomGrid`, `RoutingLayer`, and `AutoBreeder`. This IS the heartbeat of a living system.

3. **`HolonomyConsensus`** from `nexus/distributed_consensus.py` — PBFT consensus for fleet-wide decisions. `propose_state_change("room_grid_resize", {"n": 100})` → `commit_if_quorum()`. This is how the fleet makes democratic decisions.

### Is Any of It Extractable?

Yes, but it's entangled. The modules reference each other extensively. Clean extraction requires either:

**Option A (recommended):** Use `claw_fleet_bridge.py` as-is. Run sunset-ecosystem as a background service. Other systems call its REST API. Zero extraction needed.

**Option B:** Extract individual modules with their dependencies:
- JEPA: `nerve/jepa.py` (depends only on PyTorch)
- Consensus: `nexus/distributed_consensus.py` (depends only on stdlib)
- Metronome: `nerve/metronome.py` (depends on room_grid, routing, breeder_daemon — larger extraction)

### Integration Plan

```bash
# Option A: Run as background service
cd /home/eileen/projects/study-sunset-ecosystem
python3 claw_fleet_bridge.py --port 8850 &
```

```python
# Option B: Extract JEPA into collective-unconscious
# Copy nerve/jepa.py → collective-unconscious/src/jepa/nerve.py
from nerve.jepa import MinimalJEPA, JEPASwarm

# Use in collective-unconscious's prediction layer
swarm = JEPASwarm(n_fibers=5, input_dim=64, latent_dim=16)
for signal in sensor_stream:
    latents = swarm.encode(signal)  # 5 different latent representations
    novelty = swarm.detect_novelty(signal)
```

**File paths:**
- Source: `/home/eileen/projects/study-sunset-ecosystem/{nerve,nexus,claw_fleet_bridge}.py`
- Target: Background service at localhost:8850, or extract to `/home/eileen/projects/collective-unconscious/src/jepa/`

**Effort:** 1-2 hours (Option A: run as service), 1-2 days (Option B: clean extraction)
**Priority:** MEDIUM — valuable but not blocking any current integration

---

## 10. cns-bridge — The Signal Bus

### What the Code ACTUALLY Does

A filesystem-based message bus using the USCP protocol. Three layers:

**`Packet`** — The message format. JSON-serialized with header (origin_id, packet_id, destination_id, timestamp, intent, priority, schema, signature) and body (data dict, message string).

**`FileSystemTransport`** — Atomic file-based send/receive. Writes to outbox directory, reads from inbox. Uses atomic temp+rename for crash safety. Packets are `.uscp.json` files.

```python
DEFAULT_INBOX = "/mnt/c/Users/casey/.hermes/cns_inbox"
DEFAULT_OUTBOX = "/mnt/c/Users/casey/.hermes/cns_outbox"
```

**`Agent`** — Base class for bus participants. `send(intent, data, message, priority, destination)`, `receive()`, `handle(packet)` (override), `start_heartbeat()` (background polling).

**`Protocol`** — Intent types (SENSE, COMMAND, QUERY, RESPONSE, ALERT, HEARTBEAT, REGISTER, ESCALATION), Priority levels (LOW, NORMAL, HIGH, CRITICAL), Escalation rules (auto-bump priority after timeout).

### Three Most Important Components

1. **`Agent.send(intent, data, priority, destination) → Packet`** — The primary communication method. Builds, signs, and atomically writes a packet.

2. **`FileSystemTransport.poll(origin_id) → Iterable[Packet]`** — Non-blocking drain of inbox. Yields all matching packets, removing each.

3. **`ProtocolContext.check_escalation(sent_at, priority, has_response) → Priority`** — Auto-escalation. If a HIGH packet gets no response in 30s, bump to CRITICAL.

### Is It Being USED by New Systems?

**No.** The CNS bridge is used by:
- `wesley-cns-adapter` (Wesley's communication channel)
- The Living Minds (some agents)
- Legacy Hermes components

The new systems — mud-engine, collective-unconscious, slackwater stack, emergence-engine, smp-notebook, zeroclaw — do NOT use CNS. They communicate through ad-hoc HTTP calls, direct file access, or not at all.

### What It Takes to Wire mud-engine Through CNS

The mud-engine is TypeScript. CNS bridge is Python. The bridge needs a TypeScript client or an HTTP gateway.

**Recommended approach:** Write a thin TypeScript CNS client that writes/reads the same `.uscp.json` files.

```typescript
// In mud-engine/packages/cns-bridge/src/index.ts (NEW PACKAGE)
import * as fs from 'fs';
import * as path from 'path';
import * as crypto from 'crypto';

const CNS_INBOX = process.env.CNS_INBOX || '/mnt/c/Users/casey/.hermes/cns_inbox';
const CNS_OUTBOX = process.env.CNS_OUTBOX || '/mnt/c/Users/casey/.hermes/cns_outbox';

export interface Packet {
  header: {
    origin_id: string;
    packet_id: string;
    destination_id: string;
    timestamp: string;
    intent: string;
    priority: string;
  };
  body: { data: Record<string, unknown>; message: string };
}

export class CNSAgent {
  constructor(private agentId: string, private inbox = CNS_INBOX, private outbox = CNS_OUTBOX) {
    fs.mkdirSync(inbox, { recursive: true });
    fs.mkdirSync(outbox, { recursive: true });
  }

  send(intent: string, data: Record<string, unknown>, message = '', priority = 'normal', destination = 'hermes'): Packet {
    const packet: Packet = {
      header: {
        origin_id: this.agentId,
        packet_id: crypto.randomUUID(),
        destination_id: destination,
        timestamp: new Date().toISOString(),
        intent, priority,
      },
      body: { data, message },
    };
    const filename = `${this.agentId}_${packet.header.packet_id}.uscp.json`;
    const target = path.join(this.outbox, filename);
    const tmp = target + '.tmp';
    fs.writeFileSync(tmp, JSON.stringify(packet, null, 2));
    fs.renameSync(tmp, target);  // atomic
    return packet;
  }

  receive(): Packet | null {
    const files = fs.readdirSync(this.inbox)
      .filter(f => f.endsWith('.uscp.json'))
      .sort((a, b) => fs.statSync(path.join(this.inbox, a)).mtimeMs - fs.statSync(path.join(this.inbox, b)).mtimeMs);
    for (const file of files) {
      try {
        const content = fs.readFileSync(path.join(this.inbox, file), 'utf-8');
        const packet = JSON.parse(content) as Packet;
        fs.unlinkSync(path.join(this.inbox, file));  // remove after read
        return packet;
      } catch { continue; }
    }
    return null;
  }
}
```

Then in mud-engine's event-bus:
```typescript
// In mud-engine/packages/event-bus/src/cns-adapter.ts (NEW)
import { CNSAgent } from '@mud-engine/cns-bridge';

const cns = new CNSAgent('mud-engine');

// Forward mud-engine events to CNS
eventBus.on('trigger', (event) => {
  cns.send('sense', event.data, event.description, 'normal', 'hermes');
});

eventBus.on('alert', (alert) => {
  cns.send('alert', alert.data, alert.message, 'high', 'hermes');
});
```

**File paths:**
- Source: `/home/eileen/projects/cns-bridge/src/cns_bridge/{transport,agent,protocol,packet}.py`
- Target: `/home/eileen/projects/mud-engine/packages/cns-bridge/` (new package)
- Also: `/home/eileen/projects/mud-engine/packages/event-bus/src/cns-adapter.ts` (new)

**Effort:** 1 day (TS client + event-bus adapter + tests)
**Priority:** HIGH — every new system should communicate through CNS. The lack of a shared bus is the biggest integration gap in the fleet.

---

## Priority Matrix

| Repo | Impact | Effort | Priority | Why |
|------|--------|--------|----------|-----|
| **batten-spline** | 🔴 Critical | 3-4h | **CRITICAL** | Replaces manual model routing with self-improving system. 131 tests. |
| **cns-bridge** | 🔴 Critical | 1 day | **CRITICAL** | Every system needs to communicate. The TS client is the missing piece. |
| **casting-call** | 🟠 High | 3h | **HIGH** | One import replaces TOOLS.md's routing table. Already has our models. |
| **confidence-cascade** | 🟠 High | 2h | **HIGH** | Every pipeline needs confidence scoring. npm package, ready to import. |
| **slackwater-perception** | 🟠 High | 4-6h | **HIGH** | Fills the hermes-perception gap. encode_game_state() is the bridge. |
| **thought-amplifier** | 🟠 High | 2-3h | **HIGH** | Free overnight compute. Morning briefings already write to workspace. |
| **zeroclaw + casting-call** | 🟡 Medium | 3h | **MEDIUM** | Gives ZeroClaw agents intelligent model selection per task. |
| **stigmergy** | 🟡 Medium | 4-6h | **MEDIUM** | Vibe propagation needs spatial-registry to be complete first. |
| **forgemaster (grimoire)** | 🟡 Medium | 1 day | **MEDIUM** | Fleet spell library. Novel and useful but not blocking. |
| **log-tensor** | 🟢 Low | 1-2 days | **LOW** | Research code. Math is sound but needs validation against real data. |
| **study-sunset-ecosystem** | 🟢 Low | 1-2h (svc) / 1-2d (extract) | **MEDIUM** | Run as background service for JEPA/consensus. Extraction is heavy. |

---

## The Critical Path

If I could only do THREE things tomorrow:

1. **Wire batten-spline into mud-engine's strategy-guild** (3-4h)
   - Self-improving model routing replaces manual decisions
   - Every prompt gets routed based on proven outcomes, not guesses

2. **Write the TypeScript CNS client and wire mud-engine events** (1 day)
   - Every mud-engine trigger, alert, and state change flows through CNS
   - Other agents (Living Minds, Wesley, Tap agents) can hear and respond

3. **Import casting-call as the fleet's model selector** (3h)
   - `cast("intent_parse") → "SEED_MINI"` — one function replaces a mental model
   - TOOLS.md becomes documentation, not the source of truth

These three integrations connect the four most important systems (mud-engine, CNS, model routing, agent communication) and unlock everything else.

---

*Written at 9 PM on a Sunday. The code is the truth. Everything else is commentary.*
