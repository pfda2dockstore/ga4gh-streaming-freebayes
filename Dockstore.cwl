baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
id: ga4gh-streaming-freebayes
inputs:
  chromosome:
    doc: Run on this chromosome only (1-22/X/Y)
    inputBinding:
      position: 4
      prefix: --chromosome
    type: string?
  endpoint:
    default: http://htsnexus.rnd.dnanex.us/v1/reads
    doc: GA4GH Streaming API endpoint
    inputBinding:
      position: 2
      prefix: --endpoint
    type: string
  namespace:
    default: BroadHiSeqX_b37
    doc: GA4GH Streaming API path
    inputBinding:
      position: 3
      prefix: --namespace
    type: string
  output_name:
    default: trio
    doc: How to name the output VCF file
    inputBinding:
      position: 5
      prefix: --output_name
    type: string
  samples:
    default: NA12878 NA12891 NA12892
    doc: space-separated list of samples to call
    inputBinding:
      position: 1
      prefix: --samples
    type: string
label: GA4GH Streaming FreeBayes
outputs:
  vcf:
    doc: bgzipped VCF file
    outputBinding:
      glob: vcf/*
    type: File
requirements:
- class: DockerRequirement
  dockerOutputDirectory: /data/out
  dockerPull: pfda2dockstore/ga4gh-streaming-freebayes:2
s:author:
  class: s:Person
  s:name: Mike Lin
