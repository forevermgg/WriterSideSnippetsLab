## strings 搜索so字符串工具
```bash
❯ strings -a libc++_shared.so | grep use_face
_ZNKSt6__ndk16locale9use_facetERNS0_2idE
_ZNKSt6__ndk16locale9use_facetERNS0_2idE
use_facet
_ZNSt6__ndk19use_facetINS_5ctypeIcEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::ctype<char> >
_ZNSt6__ndk19use_facetINS_7num_getIcNS_19istreambuf_iteratorIcNS_11char_traitsIcEEEEEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::num_get<char> >
_ZNSt6__ndk19use_facetINS_5ctypeIwEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::ctype<wchar_t> >
_ZNSt6__ndk19use_facetINS_7num_getIwNS_19istreambuf_iteratorIwNS_11char_traitsIwEEEEEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::num_get<wchar_t> >
_ZNSt6__ndk19use_facetINS_7num_putIcNS_19ostreambuf_iteratorIcNS_11char_traitsIcEEEEEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::num_put<char> >
_ZNSt6__ndk19use_facetINS_7num_putIwNS_19ostreambuf_iteratorIwNS_11char_traitsIwEEEEEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::num_put<wchar_t> >
_ZNSt6__ndk19use_facetINS_7codecvtIcc9mbstate_tEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::codecvt<char, char, mbstate_t> >
_ZNSt6__ndk19use_facetINS_7codecvtIwc9mbstate_tEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::codecvt<wchar_t, char, mbstate_t> >
_ZNKSt6__ndk16locale5__imp9use_facetEl
_ZNSt6__ndk19use_facetINS_8numpunctIcEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::numpunct<char> >
_ZNSt6__ndk19use_facetINS_8numpunctIwEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::numpunct<wchar_t> >
_ZNSt6__ndk19use_facetINS_10moneypunctIcLb1EEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::moneypunct<char, true> >
_ZNSt6__ndk19use_facetINS_10moneypunctIcLb0EEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::moneypunct<char, false> >
_ZNSt6__ndk19use_facetINS_10moneypunctIwLb1EEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::moneypunct<wchar_t, true> >
_ZNSt6__ndk19use_facetINS_10moneypunctIwLb0EEEEERKT_RKNS_6localeE
use_facet<std::__ndk1::moneypunct<wchar_t, false> >
_ZNKSt6__ndk16locale5__imp9use_facetEl
_ZNKSt6__ndk16locale9use_facetERNS0_2idE
```