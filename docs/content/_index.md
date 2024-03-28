---
title: Welcome to the trust store testing experiment
geekdocNav: false
geekdocAlign: center
geekdocAnchor: false
---

In this repo we've tried to have a living breathing documentation of the various ways a TLS trust store is set in any environments.

We are here to conquer those pesky `X.509 Certificate Signed by Unknown Authority` errors !

We do this by running real tests in each environment in docker and report the results in this docsite.
We document the steps that we took for each distribution, the status of the run, and the diff in the filesystem as a result of running distro specific best practices steps.

{{< button size="large" >}}Environments list{{< /button >}}

## Features overview

{{< columns >}}

### Many distros and environments covered 

You will hopefully find in the current catalog the specific distro or environment you're using. Save time by knowing exactly how trust is configured for that environment, backed by a real test!

<--->

### Many ways to set the trust 

In each `.bats` file in our repository will run what we think is the "correct" canonical way to add a certificate to the trust store.
This usually involves running some special commands, but using the container layer diff, one can bypass this and learn how it can be done with simple mounts in some cases.

This is crucial for Kubernetes projects such as the trust-manager project. Where we can simply mount our trusted certificates at the correct path

<--->

### Fully open source with an (un)license

We look forward to your PRs adding any environment you seek to make this tool more useful to the community. \
We hope this small effort would help decision makers standardize on set standards for configuring TLS trust stores in the future!

{{< /columns >}}
