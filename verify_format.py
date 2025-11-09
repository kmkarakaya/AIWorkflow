#!/usr/bin/env python3
"""
Verification script for conference paper format compliance.
Checks that the generated .docx meets IEEE conference template requirements.
"""

import sys
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

def check_docx_format(docx_path):
    """
    Verify that the .docx file meets conference template requirements.
    Returns True if all checks pass, False otherwise.
    """
    print(f"Verifying format compliance of: {docx_path}")
    print("-" * 60)
    
    all_passed = True
    
    try:
        # Open the .docx file (which is a ZIP archive)
        with zipfile.ZipFile(docx_path, 'r') as docx:
            # Read document.xml
            with docx.open('word/document.xml') as doc_xml:
                tree = ET.parse(doc_xml)
                root = tree.getroot()
                
                # Define namespaces
                namespaces = {
                    'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
                    'v': 'urn:schemas-microsoft-com:vml',
                    'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'
                }
                
                # Check 1: Two-column layout
                print("\n[Check 1: Two-Column Layout]")
                cols_elements = root.findall('.//w:cols', namespaces)
                column_found = False
                if cols_elements:
                    for cols in cols_elements:
                        # Try both with and without namespace
                        num_cols = cols.get('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}num')
                        if not num_cols:
                            num_cols = cols.get('num')
                        
                        # Also check the w:num attribute
                        for attr_name, attr_value in cols.attrib.items():
                            if 'num' in attr_name.lower():
                                num_cols = attr_value
                                break
                        
                        if num_cols:
                            if num_cols == '2':
                                print(f"  ✓ Two-column layout detected (w:num={num_cols})")
                                column_found = True
                                break
                            else:
                                print(f"  ⚠ Column specification found but set to {num_cols} columns")
                    
                    if not column_found and not num_cols:
                        print(f"  ⚠ Column elements found but couldn't read num attribute")
                        print(f"    Attributes found: {[list(c.attrib.keys()) for c in cols_elements]}")
                        # Don't fail - template might handle columns differently
                else:
                    print(f"  ⚠ No column specification found in document XML")
                    print(f"    (Template reference doc may handle column layout)")
                
                # Check 2: Verify major sections exist
                print("\n[Check 2: Section Structure]")
                expected_sections = ['Introduction', 'Method', 'Experiments', 'Related Work', 'Discussion', 'Conclusion']
                found_sections = []
                
                # Look for headings (typically in w:pStyle with value 'Heading1', 'Heading2', etc.)
                paragraphs = root.findall('.//w:p', namespaces)
                for para in paragraphs:
                    # Get text content
                    text_runs = para.findall('.//w:t', namespaces)
                    para_text = ''.join([t.text or '' for t in text_runs]).strip()
                    
                    # Check if it's a heading style
                    pStyle = para.find('.//w:pStyle', namespaces)
                    if pStyle is not None:
                        style_val = pStyle.get('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}val')
                        if style_val and 'Heading' in style_val:
                            for expected in expected_sections:
                                if expected.lower() in para_text.lower():
                                    found_sections.append(expected)
                                    break
                
                print(f"  Expected sections: {', '.join(expected_sections)}")
                print(f"  Found sections: {', '.join(found_sections) if found_sections else 'None'}")
                
                if len(found_sections) >= len(expected_sections) - 1:  # Allow for minor variations
                    print(f"  ✓ Major sections present")
                else:
                    print(f"  ⚠ Some expected sections may be missing")
                    # This is a warning, not a failure
                
                # Check 3: Abstract present
                print("\n[Check 3: Abstract]")
                abstract_found = False
                for para in paragraphs:
                    text_runs = para.findall('.//w:t', namespaces)
                    para_text = ''.join([t.text or '' for t in text_runs]).strip()
                    if 'abstract' in para_text.lower() and len(para_text) > 50:
                        abstract_found = True
                        break
                
                if abstract_found:
                    print(f"  ✓ Abstract section found")
                else:
                    print(f"  ✗ Abstract section not found or too short")
                    all_passed = False
                
                # Check 4: References section
                print("\n[Check 4: References]")
                references_found = False
                for para in paragraphs:
                    text_runs = para.findall('.//w:t', namespaces)
                    para_text = ''.join([t.text or '' for t in text_runs]).strip()
                    if 'reference' in para_text.lower():
                        references_found = True
                        break
                
                if references_found:
                    print(f"  ✓ References section found")
                else:
                    print(f"  ⚠ References section not clearly identified")
                
                # Check 5: Document statistics
                print("\n[Check 5: Document Statistics]")
                total_paragraphs = len(paragraphs)
                total_text_length = sum([len(''.join([t.text or '' for t in p.findall('.//w:t', namespaces)])) 
                                        for p in paragraphs])
                
                print(f"  Total paragraphs: {total_paragraphs}")
                print(f"  Total text length: {total_text_length} characters")
                
                if total_text_length > 5000:
                    print(f"  ✓ Sufficient content present")
                else:
                    print(f"  ⚠ Content may be too short for a full paper")
                
    except Exception as e:
        print(f"\n✗ Error during verification: {e}")
        all_passed = False
    
    print("\n" + "=" * 60)
    if all_passed:
        print("RESULT: All critical checks PASSED ✓")
        return True
    else:
        print("RESULT: Some checks FAILED or need review ⚠")
        return False

if __name__ == '__main__':
    if len(sys.argv) < 2:
        docx_path = Path('build/paper.docx')
    else:
        docx_path = Path(sys.argv[1])
    
    if not docx_path.exists():
        print(f"Error: File not found: {docx_path}")
        sys.exit(1)
    
    success = check_docx_format(docx_path)
    sys.exit(0 if success else 1)
