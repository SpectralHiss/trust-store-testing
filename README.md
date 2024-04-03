# Trust Store Testing

Taking control of trust store settings for popular distributions and runtimes

---

In this repo we've tried to have a living breathing documentation of the various ways a TLS trust store is set in any environments.

We are here to conquer those pesky `X.509 Certificate Signed by Unknown Authority` errors !

We do this by running real tests in each environment in docker and report the results in the generated `docsite`.
We document the steps that we took for each distribution, the status of the run, and the diff in the filesystem as a result of running distro specific best practices steps.


Initially inspired by [trust-manager](https://github.com/cert-manager/trust-manager/) community call research documented in : https://hackmd.io/pgzx3gYvSD-dc867JRULNw