# Changelog

## [1.3.0](https://github.com/danielberkompas/cloak_ecto/tree/1.3.0) (2024-04-06)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/v1.2.0...1.3.0)

**Fixed bugs:**

- can't define label when define MyApp.Encrypted.Binary  [\#49](https://github.com/danielberkompas/cloak_ecto/issues/49)
- Migrator breaks with Ecto.Enum field in the same schema [\#46](https://github.com/danielberkompas/cloak_ecto/issues/46)
- Trouble loading the Cloak.Ecto.PBKDF2 library [\#30](https://github.com/danielberkompas/cloak_ecto/issues/30)
- The version `1.2.0` generates an unexpected error  [\#26](https://github.com/danielberkompas/cloak_ecto/issues/26)
- Migrator doesn't handle plaintext arrays or maps with inner types [\#8](https://github.com/danielberkompas/cloak_ecto/issues/8)
- 🐛 Fix `Migrator` when schema contains `Ecto.Enum` [\#51](https://github.com/danielberkompas/cloak_ecto/pull/51) ([danielberkompas](https://github.com/danielberkompas))

**Closed issues:**

- order by [\#48](https://github.com/danielberkompas/cloak_ecto/issues/48)
- SQLite3 support? [\#45](https://github.com/danielberkompas/cloak_ecto/issues/45)
- Add a `Decimal` type [\#43](https://github.com/danielberkompas/cloak_ecto/issues/43)
- Create unique contraint for encrypted or hashed column [\#40](https://github.com/danielberkompas/cloak_ecto/issues/40)
- Documentation: cloak.migrate.ecto mix task ignores labels and is order-dependent [\#33](https://github.com/danielberkompas/cloak_ecto/issues/33)
- Remove insecure example from docs [\#29](https://github.com/danielberkompas/cloak_ecto/issues/29)
- Decrypt for postgresql's native encrypt function? [\#28](https://github.com/danielberkompas/cloak_ecto/issues/28)
- Missing function `:crypto.block_encrypt/4 ` in Erlang 24 [\#23](https://github.com/danielberkompas/cloak_ecto/issues/23)
- Not possible to compile with Ecto 3.6.0 [\#20](https://github.com/danielberkompas/cloak_ecto/issues/20)
- Support blind indexes [\#18](https://github.com/danielberkompas/cloak_ecto/issues/18)
- In multi-tenant setting [\#15](https://github.com/danielberkompas/cloak_ecto/issues/15)
- Cloak.Ecto.Type does not conform to the Ecto.Type behavior [\#12](https://github.com/danielberkompas/cloak_ecto/issues/12)

**Merged pull requests:**

- ✨ Add `Decimal` type [\#52](https://github.com/danielberkompas/cloak_ecto/pull/52) ([danielberkompas](https://github.com/danielberkompas))
- 🔒 Use 600,000 iterations in PBKDF2 SHA256 [\#50](https://github.com/danielberkompas/cloak_ecto/pull/50) ([danielberkompas](https://github.com/danielberkompas))
- Document that `:ciphers` is order-dependent [\#39](https://github.com/danielberkompas/cloak_ecto/pull/39) ([danielberkompas](https://github.com/danielberkompas))
- Add support for map and array fields in migrator [\#38](https://github.com/danielberkompas/cloak_ecto/pull/38) ([danielberkompas](https://github.com/danielberkompas))
- :pencil: Recommend HMAC over SHA256 [\#36](https://github.com/danielberkompas/cloak_ecto/pull/36) ([danielberkompas](https://github.com/danielberkompas))
- :pencil: Document fix for :default values [\#35](https://github.com/danielberkompas/cloak_ecto/pull/35) ([danielberkompas](https://github.com/danielberkompas))
- Upgrade development dependencies [\#34](https://github.com/danielberkompas/cloak_ecto/pull/34) ([danielberkompas](https://github.com/danielberkompas))
- Support wrapping plaintext in closure [\#7](https://github.com/danielberkompas/cloak_ecto/pull/7) ([voltone](https://github.com/voltone))
- Improve SHA256 equality checks [\#6](https://github.com/danielberkompas/cloak_ecto/pull/6) ([Apelsinka223](https://github.com/Apelsinka223))

## [v1.2.0](https://github.com/danielberkompas/cloak_ecto/tree/v1.2.0) (2021-06-05)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/v1.1.1...v1.2.0)

**Merged pull requests:**

- Remove pbkdf2 optional dependency, update instructions [\#25](https://github.com/danielberkompas/cloak_ecto/pull/25) ([danielberkompas](https://github.com/danielberkompas))
- Support Erlang 24 [\#24](https://github.com/danielberkompas/cloak_ecto/pull/24) ([danielberkompas](https://github.com/danielberkompas))

## [v1.1.1](https://github.com/danielberkompas/cloak_ecto/tree/v1.1.1) (2020-10-20)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/v1.1.0...v1.1.1)

## [v1.1.0](https://github.com/danielberkompas/cloak_ecto/tree/v1.1.0) (2020-10-20)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/v1.0.2...v1.1.0)

**Merged pull requests:**

- Upgrade to ecto 3.5 [\#13](https://github.com/danielberkompas/cloak_ecto/pull/13) ([drewolson](https://github.com/drewolson))

## [v1.0.2](https://github.com/danielberkompas/cloak_ecto/tree/v1.0.2) (2020-01-29)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/v1.0.1...v1.0.2)

**Closed issues:**

- Hashed, searchable columns [\#4](https://github.com/danielberkompas/cloak_ecto/issues/4)
- \(ArgumentError\) invalid or unknown [\#2](https://github.com/danielberkompas/cloak_ecto/issues/2)

**Merged pull requests:**

- Replace Flow with Task.async\_stream [\#5](https://github.com/danielberkompas/cloak_ecto/pull/5) ([wojtekmach](https://github.com/wojtekmach))
- don't forget to define your type [\#3](https://github.com/danielberkompas/cloak_ecto/pull/3) ([barberj](https://github.com/barberj))

## [v1.0.1](https://github.com/danielberkompas/cloak_ecto/tree/v1.0.1) (2019-08-09)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/v1.0.0...v1.0.1)

## [v1.0.0](https://github.com/danielberkompas/cloak_ecto/tree/v1.0.0) (2019-07-31)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/v1.0.0-alpha.0...v1.0.0)

## [v1.0.0-alpha.0](https://github.com/danielberkompas/cloak_ecto/tree/v1.0.0-alpha.0) (2018-12-31)

[Full Changelog](https://github.com/danielberkompas/cloak_ecto/compare/91a4ca35b6f96e1f12d9b4efa804af89a8e6c3eb...v1.0.0-alpha.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
