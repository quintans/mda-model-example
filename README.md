# mda-model-example
Model and template example for the MDA generator

This is a **Work in progress**

For example, define an entity model, and from this model generate SQL scripts, ER Diagrams, UML diagrams, HTML documentation describing the generated tables, generate @Entity java code, protobuf definitions, etc

execute `mvn dependency:unpack`to extract the xsd files and use them for XML Catalog for xml validation.

execute `mvn exec:java@db` to generate database artifacts

execute `mvn exec:java@be` to generate other backend artifacts