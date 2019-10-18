# Cherry picking from another forks

How to cherry pick from another forks?

```
git remote add <other-fork-alias> <other-fork-URL>
git checkout <branch>
git fetch <other-fork-alias>
git cherry-pick <commit-hash>
git push <your-fork-alias>
```

# Merge all actives versions
To upgrade this extension we analyzed other many. We started forking [the OKF datajson ext](https://github.com/avdata99/ckanext-datajson).  
Some commit is ready for cherry-picking but others don't.  

Adding external forks

```
git remote add opengov https://github.com/OpenGov-OpenData/ckanext-datajson
git remote add viderum https://github.com/ViderumGlobal/ckanext-datajson
git remote add akariv https://github.com/akariv/ckanext-datajson
git remote add gsa https://github.com/GSA/ckanext-datajson
```

Fetching
```
git fetch opengov
git fetch viderum
git fetch akariv
git fetch gsa
```

# Merging

List of analized commits:  

[OpenGov 20180309](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/ae2748f6029b08223b42b6d03ad475957876fed5): Cleaned.  
[OpenGov 20180309](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/b668dcfd23e770b21b838872ee05e6f33287eb8d) paginate data.json: Already fixed, not needed.  
[OpenGov 20180801](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/f5ab8afd54343e0207cb418467dbc7b9ec325c82): Not used, removes bureau and progma validation. We already have schemas for federal and not federal datasets. Check the differences.  
[Viderum 20180831](https://github.com/ViderumGlobal/ckanext-datajson/commit/8cb92134e6e21a25c795557ddecbe14b887e1ef9): already implemented.  
[Viderum 20180904](https://github.com/ViderumGlobal/ckanext-datajson/commit/daedda3ba769150927136a5502db23db4362b2cf) Fix getting extras: Already implemented.   
[OKF ed branch 20181119](https://github.com/okfn/ckanext-datajson/commit/a12768fd165f78112fd7f36f3d442555e7886c30): Not needed.  
[OKF ed branch 20181120](https://github.com/okfn/ckanext-datajson/commit/81b752de7c5bc91cdbc5d70736e169f1caa21a2a) Spatial as no-extra: Not needed, at ignored file.  
[OKF ed branch 20181120](https://github.com/okfn/ckanext-datajson/commit/2be2fe429f95e5b685ca715d2301f254de5588e4) Temportal as no-extra: Not needed, at ignored file.  
[OpenGov 20181207](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/784489ca0ef05659314317d3c836d0e7e4ad5aad): I moprts already fixed. Other changes was for _make_pdl_ function not used in our branch. Analyze.  
[OpenGov 20181210](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/e58fa780b18999738b0518017ca768053109fd53): In buildd_datajson file we are not using.  
[OpenGov 20181212](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/3f50f43ac77def7708c3e409449c72851890c3a0) Validation languaje: Implemented.  
[OpenGov 20181212](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/88eb76cae2aa262cf88c4d8a9e25a841e1ade771) Only proccess _type:dataset_: Do we need it?. Not implemented.  
[Viderum 20190528](https://github.com/ViderumGlobal/ckanext-datajson/commit/205e748b13cd8159d60d29696a6171c70ace62fb) Implemented, fixes for accrual_periodicity.  
[Akariv 20190425](https://github.com/akariv/ckanext-datajson/commit/407294c12dbdd290c0a829748f4a4413a25d96e1). Already fixed.   
[Akariv 20190425](https://github.com/akariv/ckanext-datajson/commit/d0386071216ec69c5981ae32cacc5c15fecf390c) More on accrual_periodicity: Implemented fix import.   
[Akariv 20190425](https://github.com/akariv/ckanext-datajson/commit/1620a73af9330108a8e9ac3a2fa40164d617b32c): Implemented _title_.  
[OpenGov 20190530](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/10691e4c2d1069782caf37dc686afee2d62832e6) Allows export map path be configurable. Implemented.  
[OpenGov 20190530](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/5915c95c5e71b2c440bce255eb187fb5ca002060): We take the new periodicity.  
[GSA 20190604](https://github.com/GSA/ckanext-datajson/commit/91254e49fba5079835943d5818cbfdb7f4aad6d7) logs for GSA. Implemented (git cherry-pick 91254e49fba5079835943d5818cbfdb7f4aad6d7).   
[Viderum 20190614](https://github.com/ViderumGlobal/ckanext-datajson/commit/33660c62bd537f664f3cd0cbd42b30277bf20141) fix SSL. Implemented.   
[Viderum 20190628](https://github.com/ViderumGlobal/ckanext-datajson/commit/873e7c83018ae23eb29c56164561d3f637625f7a) check mailto at mantainer_email: Already imemented.   
[OpenGov 20190819](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/61f216e487dd3a530c61cf8672bd71e425e76160): Not sure, ignored.  
[OpenGov 20190827](https://github.com/OpenGov-OpenData/ckanext-datajson/commit/0d900484a70c2030dccae7511a80e298e081841d) Don't add resources to data.json if it's missing a url: Implemented
[Akariv 20190910](https://github.com/akariv/ckanext-datajson/commit/0fa0cd1c6cc86afc900bab49fe4ac686ab1f6bfa) fix import: implemented.   


## Needed analysis

- [ ] Do we need the build_datajson.py file?
- [ ] Do we need to validate as required for bureau and progman codes since we have schemas for federal and non-federal resources?
- [ ] OpenGov fork seems is in use and it's little different. We need to talk and merge.
  - [ ] OpenGov fork uses _make_edi_ and _make_pdl_ function. Do we need them?