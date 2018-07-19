# Swift Playground For API Models

a Swift Playground showing examples of a methodology implementing API-layer Data Transfer Objects (DTOs) and then converting
those to Domain Objects (DOs) that are better suited for use in swift code.

This two step approach solves for the problems where there is uncertainty about what data the API will returns. The problem can be solved using many tools like better specifications (Swagger) and contract testing (Pact). However many APIs will evolve in the future and may change their current contract. Also many APIs refuse to give guarantees about the content of their data because it comes from some external sources. Client API developers are responsible for creating robust and permissive clients following the Robustness Principle.

> Be conservative in what you do,
> be liberal in what you accept from others.
> -- [Robustness Principle](https://en.wikipedia.org/wiki/Robustness_principle)

This is a general law used in the implementation of network protocols and browsers. From the point of view of client application developers we can state these principles that

> Don’t break the entire user experience if only a part of the API response violates your expectations.

> Accept (almost) anything the API sends, but don’t let that uncertainty/complexity into the rest of your app code.

This playground is a work in progress showing how to follow these principles in Swift API Decoding. More explanations to follow.
