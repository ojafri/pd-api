# batch

this folder contains ingesters used to import file based data.

there are currently two styles of ingesters:

1. bulk
1. transactional

each style has their tradeoffs and are described in more detail below.

## bulk ingesters

- design principles
  - these ingesters make heavy use of the [Mongo Aggregation Framework](https://docs.mongodb.com/manual/aggregation/) attempting to process sets in bulk


- benefits
  1. bulk operations because they can be processed entirely on the mongo server, avoiding network roundtrips with the client program.


- drawbacks
  1. when operating on large datasets such as those obtained from CMS, they tend to tax the server heavily in terms of memory and cpu
  1. the sets are too large to be held in memory and must be swapped to disk during processing
  1. obtaining an initial cursor to process can take upwards of 15 minutes depending on the hardware
  1. required denormalization involves running subsequent ingester/ETL type processes
  1. should a restful interface be required as well, a _transactional_ style process must still be developed and maintained resulting in two styles of code that accomplish the same result

> the overall process still requires processing each cursor result at the client and sending back to mongo for an upsert type operation, so the process on the whole still involves roundtrips between the client and the server.

## transactional ingesters

- design principles
  - the so-called "client" ingesters are written in a _transactional_ style, which means that they operate on one record at a time without use of the Mongo Aggregation framework for bulk processing (although it may still be used for discrete transformation steps)


- benefits
  1. they share code with a restful channel for accomplishing write operations
    1.  incoming data and context is arranged as if it were coming in via a RESTful POST/PUT
    1. the shared code has built-in event-hooks to accomplish denormalization
    1. the shared code has built-in event-hooks to accomplish validation


- drawbacks
  1. when used in bulk processing, will result in more round-trips to the server when compared to bulk approach
