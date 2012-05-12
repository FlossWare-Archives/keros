<?xml  version = "1.0"?>

<!--

    This transforms Ant build scripts to HTML.

    Modifications:
        $Date: 2009-02-06 12:40:51 -0500 (Fri, 06 Feb 2009) $
        $Revision: 138 $
        $Author: sfloess $
        $HeadURL: https://keros.svn.sourceforge.net/svnroot/keros/trunk/src/dev/xsl/ant2html.xsl $

-->

<xsl:transform  version = "1.0"  xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"  xmlns:ant-contrib = "http://ant-contrib.sourceforge.net"  xmlns:keros = "http://keros.sourceforge.net">

    <!-- ============================================================================================= -->

    <xsl:output  method = "html"  version = "4.0"  indent = "yes"  omit-xml-declaration = "yes"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - Allow a version number.
      -
      -->
    <xsl:param  name = "pVersion"  select = "''"/>


    <!--
      -
      - Used when things are undefined...
      -
      -->
    <xsl:variable  name = "vNotDefined">
        <I>Not Defined</I>
    </xsl:variable>


    <!--
      -
      - Used when description is undefined...
      -
      -->
    <xsl:variable  name = "vNoDescription">
        <I>Description unavailable</I>
    </xsl:variable>

    <!-- ============================================================================================= -->

    <xsl:template  match = "/">
        <xsl:apply-templates  select = "project"/>
    </xsl:template>

    <!--
      -
      - Template to process root element...
      -
      -->
    <xsl:template  match = "project">
        <xsl:variable  name = "vTitle"  select = "concat (@name, ' ', $pVersion)"/>

        <html>
            <head>
                <title>
                    <xsl:value-of select = "$vTitle"/>
                </title>
            </head>

            <body>
                <center><h1><xsl:value-of select = "$vTitle"/></h1></center>

                <!--
                  -
                  - Output the description...
                  -
                  -->
                <xsl:apply-templates  select = "description"  mode = "description-choice-mode"/>

                <!--
                  -
                  - Output table of contents information...
                  -
                  -->
                <xsl:apply-templates  select = "."  mode = "toc-mode"/>

                <!--
                  -
                  - Output body...
                  -
                  -->
                <xsl:apply-templates  select = "."  mode = "body-mode"/>
            </body>
        </html>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits summary information about the build script...
      -
      -->
    <xsl:template  match = "project"  mode = "toc-mode">
        <h3>Table Of Contents</h3>

        <ul>
            <li><a  href = "#summary">Summary</a></li>
            <li><a  href = "#details">Details</a></li>
            <li><a  href = "#property_declarations">Property Declarations</a></li>
            <li><a  href = "#depends_list">Depends List</a></li>
        </ul>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "project"  mode = "body-mode">
        <!--
          -
          - Output summary information...
          -
          -->
        <xsl:apply-templates  select = "."  mode = "summary-mode"/>

        <!--
          -
          - Output detailed information...
          -
          -->
        <xsl:apply-templates  select = "."  mode = "detail-choice-mode"/>

        <!--
          -
          - Output properties information...
          -
          -->
        <xsl:apply-templates  select = "."  mode = "properties-choice-mode"/>

        <!--
          -
          - Output depends list...
          -
          -->
        <xsl:apply-templates  select = "."  mode = "depends-mode"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits summary information about the build script...
      -
      -->
    <xsl:template  match = "project"  mode = "summary-mode">
        <a  name = "summary"/>

        <center><h2>Summary</h2></center>

        <xsl:apply-templates  select = "."  mode = "import.summary-choice-mode"/>

        <xsl:apply-templates  select = "."  mode = "taskdef.summary-choice-mode"/>

        <xsl:apply-templates  select = "."  mode = "macrodef.summary-choice-mode"/>

        <xsl:apply-templates  select = "."  mode = "scriptdef.summary-choice-mode"/>

        <xsl:apply-templates  select = "."  mode = "target.summary-choice-mode"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits a summary of all imports in the build script...
      -
      -->
    <xsl:template  match = "project [ import ]"  mode = "import.summary-choice-mode">
        <h3>Import Summary</h3>
        <table  border = "true">
            <tr>
                <th  colspan = "3"  align = "center">Import Definitions</th> 
            </tr>

            <tr>
                <th  valign = "center">File</th><th  valign = "center">Description</th><th  valign = "center">Comment</th>
            </tr>

            <xsl:apply-templates  select = "import"  mode = "summary-mode">
                <xsl:sort  select = "@file"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <!--
      -
      -  No import's do nothing...
      -
      -->
    <xsl:template  match = "project"  mode = "import.summary-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits a summary of all taskdefs defined in the build script...
      -
      -->
    <xsl:template  match = "project [ taskdef ]"  mode = "taskdef.summary-choice-mode">
        <h3>Task Definition Summary</h3>
        <table  border = "true">
            <tr>
                <th  colspan = "3"  align = "center">Task Definitions</th> 
            </tr>

            <tr>
                <th  valign = "center">Resource</th><th  valign = "center">Description</th><th  valign = "center">Comment</th>
            </tr>

            <xsl:apply-templates  select = "taskdef"  mode = "summary-mode">
                <xsl:sort  select = "@resource"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <!--
      -
      -  No taskdef's do nothing...
      -
      -->
    <xsl:template  match = "project"  mode = "taskdef.summary-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits a summary of all macrodefs defined in the build script...
      -
      -->
    <xsl:template  match = "project [ macrodef ]"  mode = "macrodef.summary-choice-mode">
        <h3>Macro Definition Summary</h3>
        <table  border = "true">
            <tr>
                <th  colspan = "3"  align = "center">Macro Definitions</th> 
            </tr>

            <tr>
                <th  valign = "center">Name</th>
                <th  valign = "center">Description</th>
                <th  valign = "center">URI</th>
            </tr>

            <xsl:apply-templates  select = "macrodef"  mode = "summary-mode">
                <xsl:sort  select = "@name"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <!--
      -
      -  No macrodef's do nothing...
      -
      -->
    <xsl:template  match = "project"  mode = "macrodef.summary-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits a summary of all scriptdefs defined in the build script...
      -
      -->
    <xsl:template  match = "project [ scriptdef ] "  mode = "scriptdef.summary-choice-mode">
        <h3>Script Definition Summary</h3>
        <table  border = "true">
            <tr>
                <th  colspan = "4"  align = "center">Script Definitions</th> 
            </tr>

            <tr>
                <th  valign = "center">Name</th>
                <th  valign = "center">Language</th>
                <th  valign = "center">Description</th>
                <th  valign = "center">URI</th>
            </tr>

            <xsl:apply-templates  select = "scriptdef"  mode = "summary-mode">
                <xsl:sort  select = "@name"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <!--
      -
      -  No scriptdef's do nothing...
      -
      -->
    <xsl:template  match = "project"  mode = "scriptdef.summary-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits a summary of all targets defined in the build script...
      -
      -->
    <xsl:template  match = "project [ target ]"   mode = "target.summary-choice-mode">
        <h3>Target Summary</h3>

        <table  border = "true">
            <tr>
                <th  colspan = "4"  align = "center">Target Definitions</th> 
            </tr>

            <tr>
                <th  valign = "center">Name</th>
                <th  valign = "center">Depends</th>
                <th  valign = "center">Unless</th>
                <th  valign = "center">Description</th>
            </tr>

            <xsl:apply-templates  select = "target"  mode = "summary-mode">
                <xsl:sort  select = "@name"/>
            </xsl:apply-templates>
        </table>
    </xsl:template>

    <!--
      -
      -  No target's do nothing...
      -
      -->
    <xsl:template  match = "project"  mode = "target.summary-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits information on an import element...
      -
      -->
    <xsl:template  match = "import"  mode = "summary-mode">
        <tr>
            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "file-choice-mode"/>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "description-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "previous-comment-mode"/>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits information on a taskdef element...
      -
      -->
    <xsl:template  match = "taskdef"  mode = "summary-mode">
        <tr>
            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "resource-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "description-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "previous-comment-mode"/>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits summary information on a macrodef element...
      -
      -->
    <xsl:template  match = "macrodef"  mode = "summary-mode">
        <tr>
            <td  valign = "top">
                <!--
                  -
                  - Emitting a link in the document so one can navigate from summary to
                  - detail...
                  -
                  -->
                <a>
                    <xsl:attribute  name = "href">
                        <xsl:value-of select = "'#'"/>
                        <xsl:value-of select = "@name"/>
                    </xsl:attribute>

                    <xsl:value-of select = "@name"/>
                </a>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "description-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "uri-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits summary information on a scriptdef element...
      -
      -->
    <xsl:template  match = "scriptdef"  mode = "summary-mode">
        <tr>
            <td  valign = "top">
                <!--
                  -
                  - Emitting a link in the document so one can navigate from summary to
                  - detail...
                  -
                  -->
                <a>
                    <xsl:attribute  name = "href">
                        <xsl:value-of select = "'#'"/>
                        <xsl:value-of select = "@name"/>
                    </xsl:attribute>

                    <xsl:value-of select = "@name"/>
                </a>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "language-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "description-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "uri-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits summary information on a target element...
      -
      -->
    <xsl:template  match = "target"  mode = "summary-mode">
        <tr>
            <td  valign = "top">
                <!--
                  -
                  - Emitting a link in the document so one can navigate from summary to
                  - detail...
                  -
                  -->
                <a>
                    <xsl:attribute  name = "href">
                        <xsl:value-of select = "'#'"/>
                        <xsl:value-of select = "@name"/>
                    </xsl:attribute>

                    <xsl:value-of select = "@name"/>
                </a>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "target.depends-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "target.unless-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>

            <td>
                <xsl:apply-templates  select = "."  mode = "description-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits details about the build script...
      -
      -->
    <xsl:template  match = "project [ macrodef | scriptdef | target ]"  mode = "detail-choice-mode">
        <a  name = "details"/>

        <center><h2>Details</h2></center>

        <xsl:apply-templates  select = "."  mode = "macrodef.detail-choice-mode"/>

        <xsl:apply-templates  select = "."  mode = "scriptdef.detail-choice-mode"/>

        <xsl:apply-templates  select = "."  mode = "target.detail-choice-mode"/>
    </xsl:template>

    <!--
      -
      - If not macrodef, scriptdef or target do nothing...
      -
      -->
      <xsl:template  match = "project"  mode = "detail-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits details of all macrodefs defined in the build script...
      -
      -->
    <xsl:template  match = "project [ macrodef ]"  mode = "macrodef.detail-choice-mode">
        <h3>Macro Definition Details</h3>

        <xsl:apply-templates  select = "macrodef"  mode = "detail-mode">
            <xsl:sort  select = "@name"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template  match = "project"  mode = "macrodef.detail-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits details of all scriptdefs defined in the build script...
      -
      -->
    <xsl:template  match = "project [ scriptdef ]"  mode = "scriptdef.detail-choice-mode">
        <h3>Script Definition Details</h3>

        <xsl:apply-templates  select = "scriptdef"  mode = "detail-mode">
            <xsl:sort  select = "@name"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template  match = "project"  mode = "scriptdef.detail-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits details of all targets defined in the build script...
      -
      -->
    <xsl:template  match = "project [ target ]"  mode = "target.detail-choice-mode">
        <h3>Target Detail</h3>

        <xsl:apply-templates  select = "target"  mode = "detail-mode">
            <xsl:sort  select = "@name"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template  match = "project"  mode = "target.detail-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits detailed information on a macrodef element...
      -
      -->
    <xsl:template  match = "macrodef"  mode = "detail-mode">
        <h3>
            <!--
              -
              - Emitting an anchor that can be selected from the summary section...
              -
              -->
            <a>
                <xsl:attribute  name = "name">
                    <xsl:value-of select = "@name"/>
                </xsl:attribute>

                <xsl:value-of select = "@name"/>
            </a>
        </h3>

        <xsl:apply-templates  select = "."  mode = "description-choice-mode">
            <xsl:with-param  name = "pDefaultValue"  select = "$vNoDescription"/>
        </xsl:apply-templates>

        <p/>

        <xsl:apply-templates  select = "."  mode = "attribute.detail-choice-mode"/>

        <p/>

        <ul>
            <xsl:apply-templates  select = "."  mode = "previous-comment-mode"/>
        </ul>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits detailed information on a scriptdef element...
      -
      -->
    <xsl:template  match = "scriptdef"  mode = "detail-mode">
        <h3>
            <!--
              -
              - Emitting an anchor that can be selected from the summary section...
              -
              -->
            <a>
                <xsl:attribute  name = "name">
                    <xsl:value-of select = "@name"/>
                </xsl:attribute>

                <xsl:value-of select = "@name"/>
            </a>
        </h3>

        <xsl:apply-templates  select = "."  mode = "description-choice-mode">
            <xsl:with-param  name = "pDefaultValue"  select = "$vNoDescription"/>
        </xsl:apply-templates>

        <p/>

        <xsl:apply-templates  select = "."  mode = "attribute.detail-choice-mode"/>

        <p/>

        <ul>
            <xsl:apply-templates  select = "."  mode = "previous-comment-mode"/>
        </ul>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits details of an attribute defined on an element in the build script...
      -
      -->
    <xsl:template  match = "* [ attribute ]"  mode = "attribute.detail-choice-mode">
        <table  border = "true">
            <tr>
                <th  colspan = "3"  align = "center">Attribute Definitions</th> 
            </tr>

            <tr>
                <th  valign = "center">Name</th>
                <th  valign = "center">Description</th>
                <th  valign = "center">Default</th>
            </tr>

            <xsl:apply-templates  select = "attribute"  mode = "detail-mode"/>
        </table>
    </xsl:template>

    <xsl:template  match = "*"  mode = "attribute.detail-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits detailed information on an attribute of an element...
      -
      -->
    <xsl:template  match = "attribute"  mode = "detail-mode">
        <tr>
            <td  valign = "top"><xsl:value-of  select = "@name"/></td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "description-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNoDescription"/>
                </xsl:apply-templates>
            </td>

            <td  valign = "top">
                <xsl:apply-templates  select = "."  mode = "default-choice-mode">
                    <xsl:with-param  name = "pDefaultValue"  select = "$vNotDefined"/>
                </xsl:apply-templates>
            </td>
        </tr>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits detailed information on a target element...
      -
      -->
    <xsl:template  match = "target"  mode = "detail-mode">
        <h3>
            <!--
              -
              - Emitting an anchor that can be select from the summary section...
              -
              -->
            <a>
                <xsl:attribute  name = "name">
                    <xsl:value-of select = "@name"/>
                </xsl:attribute>

                <xsl:value-of select = "@name"/>
            </a>
        </h3>

        <xsl:apply-templates  select = "."  mode = "description-choice-mode">
            <xsl:with-param  name = "pDefaultValue"  select = "$vNoDescription"/>
        </xsl:apply-templates>

        <p/>

        <p/>

        <xsl:apply-templates  select = "."  mode = "previous-comment-mode"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "* [ normalize-space ( @default ) != '' ]"  mode = "default-choice-mode">
        <xsl:value-of  select = "@default"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "default-choice-mode">
        <xsl:param  name = "pDefaultValue"/>

        <xsl:copy-of  select = "$pDefaultValue"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "* [ normalize-space ( @depends ) != '' ]"  mode = "target.depends-choice-mode">
        <xsl:value-of  select = "@depends"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "target.depends-choice-mode">
        <xsl:param  name = "pDefaultValue"/>

        <xsl:copy-of  select = "$pDefaultValue"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--
      -
      - This template emits the description of the build script...
      -
      -->
    <xsl:template  match = "description [ normalize-space ( text () ) != '' ]"  mode = "description-choice-mode">
        <h3><xsl:value-of select = "normalize-space ( text () )"/></h3>
    </xsl:template>

    <xsl:template  match = "description"  mode = "description-choice-mode"/>

    <xsl:template  match = "* [ normalize-space ( @description ) != '' ]"  mode = "description-choice-mode">
        <xsl:value-of  select = "@description"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "description-choice-mode">
        <xsl:param  name = "pDefaultValue"/>

        <xsl:copy-of  select = "$pDefaultValue"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "* [ normalize-space ( @language ) != '' ]"  mode = "language-choice-mode">
        <xsl:value-of  select = "@language"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "language-choice-mode">
        <xsl:param  name = "pDefaultValue"/>

        <xsl:copy-of  select = "$pDefaultValue"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "* [ normalize-space ( @resource ) != '' ]"  mode = "resource-choice-mode">
        <xsl:value-of  select = "@resource"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "resource-choice-mode">
        <xsl:param  name = "pDefaultValue"/>

        <xsl:copy-of  select = "$pDefaultValue"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "* [ normalize-space ( @unless ) != '' ]"  mode = "target.unless-choice-mode">
        <xsl:value-of  select = "@unless"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "target.unless-choice-mode">
        <xsl:param  name = "pDefaultValue"/>

        <xsl:copy-of  select = "$pDefaultValue"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "* [ normalize-space ( @uri ) != '' ]"  mode = "uri-choice-mode">
        <xsl:value-of  select = "@uri"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "uri-choice-mode">
        <xsl:param  name = "pDefaultValue"/>

        <xsl:copy-of  select = "$pDefaultValue"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "* [ normalize-space ( @file ) != '' ]"  mode = "file-choice-mode">
        <xsl:value-of select = "@file"/>
    </xsl:template>

    <xsl:template  match = "*"  mode = "file-choice-mode"/>

    <!-- ============================================================================================= -->

    <!--

        This template will emit a comment if it exists before the current node.

    -->
    <xsl:template  match = "*"  mode = "previous-comment-mode">
        <xsl:value-of  select = "preceding-sibling::node () [ self::comment () ] [ 1 ]"  disable-output-escaping = "yes"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "project"  mode = "properties-choice-mode">
        <a  name = "property_declarations"/>

        <center>
            <h2>
                Property Declarations
            </h2>
        </center>

        This section highlights all properties set by scope.  For example, properties may
        be set at the project level, macrodef level or target level.  This section
        <i>only</i> lists the property names - not their values.

        <ul>
            Project Level

            <xsl:apply-templates  mode = "property.detail-mode"/>
        </ul>

        <ul>
            Macrodef(s)

            <xsl:apply-templates  select = "macrodef"  mode = "properties.detail-choice-mode"/>
        </ul>

        <ul>
            Target(s)

            <xsl:apply-templates  select = "target"  mode = "properties.detail-choice-mode"/>
        </ul>
    </xsl:template>

    <xsl:template  match = "* | @* | text ()"  mode = "properties-choice-mode"/>

                <!-- ================================= -->

    <xsl:template  match = "macrodef | target"  mode = "properties.detail-choice-mode">
        <ul>
            <xsl:value-of  select = "@name"/>

            <ul>
                <xsl:apply-templates  mode = "property.detail-mode"/>
            </ul>
        </ul>
    </xsl:template>

    <xsl:template  match = "* | @* | text ()"  mode = "properties.detail-mode"/>

                <!-- ================================= -->

    <xsl:template match = "basename | condition | dirname  | length | loadfile | loadresource | ant-contrib:propertyregex | keros:compute-locale | keros:compute-class-branch | keros:compute-branch | keros:auto-property | keros:set-property | keros:for | keros:load-file | keros:console-input | keros:dirname | keros:basename | keros:compute-file-extension | keros:truncate-file-extension | keros:compute-file-modification-date | keros:compute-number-left-trim | keros:compute-number-right-trim | keros:compute-number-trim | keros:compute-timestamp | keros:compute-replacement" mode = "property.detail-mode"> 
        <ul><xsl:value-of  select = "@property"/></ul>

        <xsl:apply-templates  mode = "property.detail-mode"/>
    </xsl:template>

    <xsl:template  match = "property | ant-contrib:var | keros:property-default"  mode = "property.detail-mode">
        <ul><xsl:value-of  select = "@name"/></ul>

        <xsl:apply-templates  mode = "property.detail-mode"/>
    </xsl:template>

    <xsl:template  match = "keros:compute-class-info"  mode = "property.detail-mode">
        <ul><xsl:value-of  select = "@dir-property"/></ul>
        <ul><xsl:value-of  select = "@file-property"/></ul>

        <xsl:apply-templates  mode = "property.detail-mode"/>
    </xsl:template>

    <xsl:template  match = "keros:conditional-set-property | keros:equality-set-property"  mode = "property.detail-mode">
        <ul><xsl:value-of  select = "@name"/></ul>

        <xsl:apply-templates  mode = "property.detail-mode"/>
    </xsl:template>

    <!--
        Just in case we are at the project level and emitting project
        level properties, macrodef and target will be addressed
        at a later time.
    -->
    <xsl:template  match = "macrodef | target"  mode = "property.detail-mode"/>

    <xsl:template  match = "*"  mode = "property.detail-mode">
        <xsl:apply-templates  mode = "property.detail-mode"/>
    </xsl:template>

    <!--
        Not using * here...  For some reason it was taking precedence over
        the element entitle "sequential."
    -->
    <xsl:template  match = "@* | text ()"  mode = "property.detail-mode"/>

    <!-- ============================================================================================= -->

    <xsl:template  match = "project"  mode = "depends-mode">
        <a  name = "depends_list"/>

        <center>
            <h2>
                Depends List
            </h2>
        </center>

        This section lists all the dependencies for targets in a hierarchical structure.

        <xsl:apply-templates  select = "target [ normalize-space ( @depends ) != '' ]"  mode = "target.depends-mode"/>
    </xsl:template>

    <!-- ============================================================================================= -->

    <xsl:template  match = "target"  mode = "target.depends-mode">
        <xsl:variable  name = "vDepends"  select = "translate ( @depends, ',', '' )"/>

        <ul>
            <xsl:value-of  select = "normalize-space ( @name )"/>

            <ul>
                <xsl:call-template  name = "depends">
                    <xsl:with-param  name = "pDepends"  select = "$vDepends"/>
                </xsl:call-template>
            </ul>
        </ul>
    </xsl:template>

    <!-- ============================================================================================= -->

    <!--

        This template is a little different and procedural (vs declarative).  We must iterate over the
        space delimited values and emit each one.

    -->
    <xsl:template  name = "depends">
        <xsl:param  name = "pDepends"/>

        <xsl:variable  name = "vPreDepend"    select = "substring-before ( $pDepends, ' ' )"/>
        <xsl:variable  name = "vPostDepends"  select = "substring-after  ( $pDepends, ' ' )"/>

        <xsl:choose>
            <xsl:when  test = "normalize-space ($vPreDepend) != ''">
                <xsl:apply-templates  select = "//target [ @name = $vPreDepend ]"  mode = "target.depends-mode"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:apply-templates  select = "//target [ @name = $pDepends ]"  mode = "target.depends-mode"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if  test = "normalize-space ( $vPostDepends ) != ''">
            <xsl:call-template  name = "depends">
                <xsl:with-param  name = "pDepends"  select = "normalize-space ( $vPostDepends )"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- ============================================================================================= -->

</xsl:transform>

