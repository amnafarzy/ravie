# Behavioral guidelines

Derived from Andrej Karpathy's observations on LLM coding pitfalls. These rules address the most common failure modes when AI writes code.

## 1. Don't assume — surface confusion

State assumptions explicitly. If uncertain, ask. If multiple interpretations exist, present them — don't pick silently. If a simpler approach exists, say so. Push back when warranted.

If something is unclear: stop. Name what's confusing. Ask.

## 2. Minimum viable code

Write the minimum code that solves the problem. Nothing speculative. No features beyond what was asked. No abstractions for single-use code. No "flexibility" or "configurability" that wasn't requested.

If you write 200 lines and it could be 50, rewrite it. Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical changes only

Change only what's needed for the current task. Don't "fix" adjacent code. Don't refactor things you weren't asked to touch. Don't remove comments or code you don't fully understand. Don't clean up imports in unrelated files.

Every change must trace directly to the task at hand.

## 4. Goal-driven verification

Transform vague instructions into verifiable goals. Instead of "make it work," define what "working" means in testable terms. Write the test first. Run it. Watch it fail. Fix the code. Watch it pass.

If you can't define done-state, the task isn't clear enough yet — go back to step 1.
