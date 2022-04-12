# integration test setup for HANA-Scaleup stack 
This terraform code creates multiple projects that are used to test variations of HANA-Scaleup deployments.
Idea is to create a project per `product_id`. Number of projects is dictated by 
[support-matrix](../../../docs/support-matrix.md). All projects are long running and meant to exist for long periods of 
time. Once the projects are created increase the GCE quotas per region. Each project will have it's own media bucket 
with installation media.
