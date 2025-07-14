# Orchestron

Orchestron is a platform for the development of robust network orchestration systems based on model-driven declarative transforms. It does the heavy lifting so you can focus on building automation that makes sense. With native support for streaming telemetry, Orchestron enables you to build reactive closed loop automation.

## Reference Implementation
A platform is only as good as the use cases it can support. That is why we are
simultaniously developing **SORESPO**, a **reference implementation** of an
Orchestron system. As a network operator and/or network service developer we
encourage you to first of all [explore SORESPO](https://github.com/orchestron-orchestrator/sorespo/blob/main/README.md)
to experience first hand how the Orchestron platform can support your
real-world use cases.

## Orchestron Design Philosophy

Automation logic is implemented primarily through *transforms* which take certain input data and transform it into other output data. Transforms are layered in order to break down problems into smaller tractable problems, similar to how structured programming introduced the idea of defining and calling functions to break down large problems into smaller problems.

The platform in itself is purely reactive, acting on input events, either configuration changes from northbound APIs or subscriptions on streaming telemetry from devices.

We try to "left shift" run time errors to compile / development time so we can detect and avoid bugs before committing code, building better and more robust automation systems. For example by turning YANG models into types, we can utilize the static type system of the programming language compiler to detect spelling mistakes or other data errors at compile time.

The ideas behind Orchestron has its roots in ideas from functional programming combined with some influence from a decade of experience in operating large IP networks using automation. We just recently started building, but we have been thinking about this for a long time. We know what we want, now we just got to write some code.
