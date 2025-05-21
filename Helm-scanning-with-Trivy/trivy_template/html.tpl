<!DOCTYPE html>
<html>
<head>
    <title>Trivy Security Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { padding: 20px; background-color: #f8f9fa; }
        .severity-LOW { color: #ffc107; }
        .severity-MEDIUM { color: #fd7e14; }
        .severity-HIGH { color: #dc3545; }
        .severity-CRITICAL { color: #6f42c1; }
        .finding-card { margin-bottom: 20px; border-radius: 5px; }
        pre { background-color: #f8f9fa; padding: 15px; border-radius: 4px; }
        .summary-table { margin-bottom: 30px; }
        .code-line { font-family: monospace; white-space: pre-wrap; }
        .collapsible { cursor: pointer; }
        .collapsible-content { display: none; padding: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mb-4">Trivy Security Report</h1>
        
        <!-- Summary Table -->
        <div class="card summary-table">
            <div class="card-header bg-primary text-white">
                Report Summary
            </div>
            <div class="card-body">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Target</th>
                            <th>Type</th>
                            <th>Misconfigurations</th>
                        </tr>
                    </thead>
                    <tbody>
                        {{ range . }}
                        <tr>
                            <td>{{ .Target }}</td>
                            <td>{{ .Type }}</td>
                            <td class="{{ if eq .MisconfSummary.Failures 0 }}text-success{{ else }}text-danger{{ end }}">
                                {{ .MisconfSummary.Failures }}
                            </td>
                        </tr>
                        {{ end }}
                    </tbody>
                </table>
                <div class="alert alert-info">
                    Legend: 
                    <span class="badge bg-success">0: Clean</span>
                    <span class="badge bg-danger">Failures</span>
                </div>
            </div>
        </div>

        <!-- Detailed Findings -->
        {{ range . }}
        {{ if gt (len .Misconfigurations) 0 }}
        <div class="card finding-card">
            <div class="card-header bg-secondary text-white">
                {{ .Target }} ({{ .Type }})
            </div>
            <div class="card-body">
                {{ range $misconf := .Misconfigurations }}
                <div class="mb-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="{{ printf "severity-%s" $misconf.Severity }}">
                            {{ $misconf.ID }} ({{ $misconf.Severity }})
                        </h5>
                        <span class="badge {{ printf "bg-%s" (lower $misconf.Severity) }}">
                            {{ $misconf.Severity }}
                        </span>
                    </div>
                    <p>{{ $misconf.Description }}</p>
                    <a href="{{ $misconf.PrimaryURL }}" target="_blank" class="btn btn-sm btn-outline-primary">
                        Documentation
                    </a>
                    
                    {{ if $misconf.CauseMetadata }}
                    <div class="mt-3 collapsible" onclick="toggleCollapse('{{ $misconf.ID }}')">
                        <h6>🔍 Code Location</h6>
                        <div id="{{ $misconf.ID }}" class="collapsible-content">
                            <pre class="code-line">{{ $misconf.CauseMetadata.Code.Lines }}</pre>
                        </div>
                    </div>
                    {{ end }}
                </div>
                <hr>
                {{ end }}
            </div>
        </div>
        {{ end }}
        {{ end }}
    </div>

    <script>
        function toggleCollapse(elementId) {
            const content = document.getElementById(elementId);
            content.style.display = content.style.display === 'none' ? 'block' : 'none';
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>